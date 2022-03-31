/* 
Title: 		econometrics midterm/project - cg-analysis

Authors		Xiao Jiang
			Sukanya Mukherjee
			Thomas Konigkramer			
			
Date		23 March 2022

Sections	1) use data for our replication of results
			2) theory: summary and dummy creation
			3) relevant plots: scatterplots and histograms
			4) first estimation: reg, variable selection 
			5) tests and corrections: heterosk., outliers, influencial points, endogeneity, instrumental variables
			6) final model
			7) import recent GDP figures			
*/

* change working directory (pwd) as needed
clear
cd C:\Users\ThomasKönigkrämer\Desktop\MMEF_2021\Econometrics\mmef_econ-proj

* 1) use, save data ***************************************************************************************************

use data_files\maketable2

merge 1:1 shortnam using data_files\maketable1
* all _merge variables have a value of 3, which means there was a successful merge across the row

* drop variables not necessary (_merge interferes with future merges)
drop euro1900 excolony cons1 cons90 democ00a cons00a loghjypl _merge

save data_files\cg-analysis, replace

use data_files\cg-analysis

* 2) theory (summary and dummies) *************************************************************************************
* generate variables needed variables for investigation

// sum

* 15 missing values generated: no information in logpgp95 for those observations, so this is expected (163-148=15)
gen gdp = exp(logpgp95)
* 40 missing values generated: no information (163-123=40)
// gen hjypl = exp(loghjypl)
gen logalat = log(lat_abst)
gen logavexpr = log(avexpr)


label variable gdp "PPP GDP pc in 1995, World Bank"
// label variable hjypl "GDP per work, Hall&Jones"
label variable logalat "log Abs(latitude of capital)/90"
label variable logavexpr "log average protection against expropriation risk"

gen neoeuro = 0
replace neoeuro = 1 if shortnam == "AUS"
replace neoeuro = 1 if shortnam == "CAN"
replace neoeuro = 1 if shortnam == "NZL"
replace neoeuro = 1 if shortnam == "USA"

* readability - rename variables, new labels, order
rename logpgp95 loggdp
rename lat_abst alat
rename extmort4 mort
rename logem4 logmort


order shortnam gdp loggdp mort logmort alat logalat avexpr logavexpr africa asia neoeuro 

sum

save data_files\cg-analysis, replace

* 3) relevant plots ***************************************************************************************************

* histograms **********************************************************************************************************

twoway histogram gdp, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity gdp, title("PPP GDP (1995)") lcolor (red) lpattern(dash)
graph export graphs\graph-histogram-gdp.png, replace
twoway histogram loggdp, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity loggdp, title("Log of PPP GDP (1995)") lcolor (red) lpattern(dash)
graph export graphs\graph-histogram-loggdp.png, replace
* detailed summary of these two variables to look at their skewness - evident from histograms
sum gdp loggdp, detail

twoway histogram mort, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity mort, title("Mortality") lcolor (red) lpattern(dash) 
graph export graphs\graph-histogram-mort.png, replace
twoway histogram logmort, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity logmort, title("Log of Mortality") lcolor (red) lpattern(dash) 
graph export graphs\graph-histogram-logmort.png, replace
sum mort logmort, detail

* clearly log transformation does not improve this variable's distribution
twoway histogram alat, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity alat, title("Absolute Latitute") lcolor (red) lpattern(dash)
graph export graphs\graph-histogram-alat.png, replace
twoway histogram logalat, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity logalat, title("Log of Absolute Latitude") lcolor (red) lpattern(dash) 
graph export graphs\graph-histogram-loghjypl.png, replace
sum alat logalat, detail

* clearly log transformation does not improve this variable's distribution
twoway histogram avexpr, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity avexpr, title("Average Protection Against Expropriation Risk") lcolor (red) lpattern(dash) 
graph export graphs\graph-histogram-avexpr.png, replace
twoway histogram logavexpr, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity logavexpr, title("Log of Protection Against Average Expropriation Risk") lcolor (red) lpattern(dash) 
graph export graphs\graph-histogram-logavexpr.png, replace
sum avexpr logavexpr, detail

* scatterplots ********************************************************************************************************

twoway scatter loggdp logmort, mcolor(pink%25)  || lfit loggdp logmort , lcolor (red) title("Effect of log settler mortality on log of PPP GDP") ytitle(Log of PPP GDP 1995) xtitle(Log of Settler mortality) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big)
graph export graphs\graph_logmort-vs-loggdp.png, replace

twoway scatter loggdp alat, mcolor(pink%25)  || lfit loggdp alat, lcolor (red%60) title("Effect of latitude of capital on log of PPP GDP") ytitle(Log of PPP GDP 1995) xtitle(Latitude of Capital) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big)
graph export graphs\graph_alat-vs-loggdp.png, replace


twoway scatter loggdp avexpr, mcolor(pink%25)  || lfit loggdp avexpr, lcolor (red) title("Effect of average expropriation risk on log of PPP GDP")  ytitle(Log of PPP GDP 1995) xtitle(Average protection against expropriation risk) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big)
graph export graphs\graph_avexpr-vs-loggdp.png, replace

twoway scatter gdp mort, mcolor(pink%25)  || lfit gdp mort, lcolor (red) title("Effect of settler mortality on PPP GDP")  ytitle(PPP GDP 1995) xtitle(Settler mortality) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big)
graph export graphs\graph_mort-vs-loggdp.png, replace

twoway scatter loggdp mort, mcolor(pink%25)  || lfit loggdp mort, lcolor (red) title("Effect of log of settler mortality on PPP GDP")  ytitle(PPP GDP 1995) xtitle(Log of Settler mortality) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big)
graph export graphs\graph_mort-vs-loggdp.png, replace

* 4) first estimation *************************************************************************************************

* variable selection, i.e. obtaining the regression we want ***********************************************************
* regression-1.png (coincides with name of png in figures)
reg loggdp alat avexpr

* regression-2.png
reg loggdp alat avexpr africa asia neoeuro
* lat_abs even less significant and neoeuro also insignficant

* regression-3.png: dropped neoeuro since insign
reg loggdp alat avexpr africa asia

* regression-4.png: dropped alat since was still insign. Including neoeuro because interesting. Neoeuro proves to be insign.
reg loggdp avexpr africa asia neoeuro

* regression-5.png: only sign. variables - this is the one we want
reg loggdp avexpr africa asia

* regression-6.png: sign. with no dummies - just for interest
reg loggdp avexpr

* final regression:
reg loggdp avexpr africa asia

* 5) tests and corrections ********************************************************************************************

* tests for heteroskedasticity ****************************************************************************************

*estat-hettest.png
estat hettest, rhs

* needs to be run somewhere else - not working on Tom's computer - have no screenshots post this
// ssc install whitetst
// whitetst

* all the same as before, but no adjusted R^2
reg loggdp avexpr africa asia, robust

* outliers
rvfplot, mlabel(shortnam)
graph export graphs\graph_outliers.png, replace

//
// predict diag_leverage, leverage
// list diag_leverage

* outliers



* influencial points

* leverage vs residuals
// lvr2plot, mlabel(shortnam)

// reg with robust

* endogeneity

* instrumental variables

* 6) final model ******************************************************************************************************

*IV - add logmort

ivregress 2sls loggdp avexpr(logmort) africa asia

* reg

* 7) import recent GDP figures ****************************************************************************************


// clear
//	
// import excel "data_files\Data_Extract_From_World_Development_Indicators.xlsx", sheet("Data") firstrow clear
//	
// drop SeriesName SeriesCode CountryName
// drop if CountryCode == ""
//
// rename CountryCode shortnam
// // drop if shortnam == ""
//
// merge 1:1 shortnam using data_files\cg-analysis
// * many mismatches - read up on how to identify them here: https://www.princeton.edu/~otorres/Merge101.pdf
// * will need to look into this