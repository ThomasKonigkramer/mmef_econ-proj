/* 
Title: 		econometrics midterm/project - cg-analysis

Authors		Xiao Jiang
			Thomas Konigkramer			
			Sukanya Mukherjee
			
Date		23 March 2022

Sections	1) use data for our replication of results
			2) theory: summary and dummy creation
			3) relevant plots: scatterplots and histograms
			4) first estimation: reg, variable selection 
			5) tests and corrections: heterosk., outliers, influencial points, endogeneity, instrumental variables
			6) final model
			7) import recent GDP figures			
*/

* change working directory (pwd) as neededclear
clear
cd C:\Users\ThomasKönigkrämer\Desktop\MMEF_2021\Econometrics\mmef_econ-proj


* 1) use, save data ***************************************************************************************************

use data_files\maketable2

merge 1:1 shortnam using data_files\maketable1
* all _merge variables have a value of 3, which means there was a successful merge across the row

* drop variables not necessary (_merge interferes with future merges)
drop euro1900 excolony cons1 cons90 democ00a cons00a loghjypl _merge other baseco

save data_files\cg-analysis, replace

use data_files\cg-analysis

* 2) theory (summary and dummies) *************************************************************************************
* generate variables needed variables for investigation

sum

* 15 missing values generated: no information in logpgp95 for those observations, so this is expected (163-148=15)
gen gdp = exp(logpgp95)
gen logalat = log(lat_abst)
gen logavexpr = log(avexpr)

gen neoeuro = 0
replace neoeuro = 1 if shortnam == "AUS"
replace neoeuro = 1 if shortnam == "CAN"
replace neoeuro = 1 if shortnam == "NZL"
replace neoeuro = 1 if shortnam == "USA"

label variable neoeuro "dummy=1 for AUS, CAN, NZL, USA"

* readability - rename variables, new labels, order
rename logpgp95 loggdp
rename lat_abst alat
rename extmort4 mort
rename logem4 logmort

label variable gdp "GDP pc in 1995"
label variable logalat "log Abs (latitude of capital)/90"
label variable logavexpr "log Average protection against expropriation risk"
label variable loggdp "log GDP pc in 1995" 
label variable mort "Settler mortality"
label variable asia "dummy=1 for Asia"
label variable avexpr "Average protection against expropriation risk"


order shortnam gdp loggdp mort logmort alat logalat avexpr logavexpr africa asia neoeuro 

* sum.png - screenshot
sum

save data_files\cg-analysis, replace

* 3) relevant plots ***************************************************************************************************

* histograms **********************************************************************************************************

twoway histogram gdp, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity gdp, title("GDP (1995)") lcolor (red) lpattern(dash)
graph export graphs\graph-histogram-gdp.png, replace
twoway histogram loggdp, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity loggdp, title("Log GDP (1995)") lcolor (red) lpattern(dash)
graph export graphs\graph-histogram-loggdp.png, replace
* detailed summary of these two variables to look at their skewness - evident from histograms
sum gdp loggdp, detail

twoway histogram mort, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity mort, title("Settler Mortality") lcolor (red) lpattern(dash) 
graph export graphs\graph-histogram-mort.png, replace
twoway histogram logmort, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity logmort, title("Log Sttler Mortality") lcolor (red) lpattern(dash) 
graph export graphs\graph-histogram-logmort.png, replace
sum mort logmort, detail

* clearly log transformation does not improve this variable's distribution
twoway histogram alat, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity alat, title("Absolute Latitute") lcolor (red) lpattern(dash)
graph export graphs\graph-histogram-alat.png, replace
twoway histogram logalat, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity logalat, title("Log Absolute Latitude") lcolor (red) lpattern(dash) 
graph export graphs\graph-histogram-logalat.png, replace
sum alat logalat, detail

* clearly log transformation does not improve this variable's distribution
twoway histogram avexpr, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity avexpr, title("Average Protection Against Expropriation Risk") lcolor (red) lpattern(dash) 
graph export graphs\graph-histogram-avexpr.png, replace
twoway histogram logavexpr, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity logavexpr, title("Log Average Protection Against Expropriation Risk") lcolor (red) lpattern(dash) 
graph export graphs\graph-histogram-logavexpr.png, replace
sum avexpr logavexpr, detail

* scatterplots ********************************************************************************************************

twoway scatter loggdp alat, mcolor(pink%25)  || lfit loggdp alat, lcolor (red%60) title("Latitude of capital vs Log GDP 1995") ytitle(Log GDP 1995) xtitle(Latitude of Capital) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big)
graph export graphs\graph_alat-vs-loggdp.png, replace


twoway scatter loggdp avexpr, mcolor(pink%25)  || lfit loggdp avexpr, lcolor (red) title("Average expropriation risk vs Log GDP 1995")  ytitle(Log GDP 1995) xtitle(Average protection against expropriation risk) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big)
graph export graphs\graph_avexpr-vs-loggdp.png, replace

twoway scatter gdp mort, mcolor(pink%25)  || lfit gdp mort, lcolor (red) title("Settler mortality vs  GDP 1995")  ytitle( GDP 1995) xtitle(Settler mortality) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big)
graph export graphs\graph_mort-vs-gdp.png, replace

twoway scatter loggdp mort, mcolor(pink%25)  || lfit loggdp mort, lcolor (red) title("Settler mortality vs Log GDP 1995")  ytitle(Log GDP 1995) xtitle(Settler mortality) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big)
graph export graphs\graph_mort-vs-loggdp.png, replace

twoway scatter loggdp logmort, mcolor(pink%25)  || lfit loggdp logmort , lcolor (red) title(" Log Settler mortality vs Log GDP 1995") ytitle(Log GDP 1995) xtitle(Log Settler mortality) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big)
graph export graphs\graph_logmort-vs-loggdp.png, replace

* 4) first estimation *************************************************************************************************

* variable selection, i.e. obtaining the regression we want ***********************************************************
* regression-1.png (coincides with name of png in figures) - no screenshot necessary here
reg loggdp avexpr

* regression-2.png - screenshot
reg loggdp avexpr alat africa asia neoeuro

* f-test.png - screenshot
test alat asia neoeuro
* failed to reject that coefficients are zero

* regression-3.png: dropped insignificant variables - screenshot
reg loggdp avexpr africa

* 5) tests and corrections ********************************************************************************************

* tests for heteroskedasticity ****************************************************************************************

*estat-hettest.png - screenshot
estat hettest, rhs
* no heteroskedasticity

* outliers and influencial points *************************************************************************************
rvfplot, mlabel(shortnam) mcolor(pink%25) graphregion(fcolor(white))
graph export graphs\graph_outliers.png, replace
 
lvr2plot, mlabel(shortnam) mcolor(pink%25) graphregion(fcolor(white))
graph export graphs\graph_lvr2plot.png, replace

* endogeneity and instrumental variables *****************************************************************************

reg loggdp avexpr africa

* ivregress-1.png
ivregress 2sls loggdp (avexpr = logmort) africa

* ivregress-2.png
ivregress 2sls loggdp (avexpr = logmort) africa asia neoeuro

* ivregress-3.png
ivregress 2sls loggdp (avexpr = logmort) africa asia

* hausmann test
* endog.png - screenshot
estat endogenous 
* over identification: check whether E(zu) = 0 - no overidenitying restrictions
// estat overid 

* 6) final model ******************************************************************************************************

ivregress 2sls loggdp (avexpr = logmort) africa asia
