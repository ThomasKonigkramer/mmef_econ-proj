/* 
Title: 		econometrics midterm/project - 

Authors		Xiao Jiang
			Sukanya Mukherjee
			Thomas Konigkramer			
			
Date		23 March 2022

Sections	1) use data for our replication of results
			2) theory: summary and dummy creation
			3) relevant plots: scatterplots and histograms
			4) first estimation: reg, outliers, influencial points 
			5) tests and corrections: heterosk., variable selection, endogeneity, instrumental variables
			6) final model
			7) import recent GDP figures
			
Suggestion: 1) regression, 2) hetero, 3) variable selection, 4) outliers and influential points, 5) endogeneity and IV
			
*/

* change working directory (pwd) as needed
clear
cd C:\Users\ThomasKönigkrämer\Desktop\MMEF_2021\Econometrics\mmef_econ-proj

* 1) use, save data ***************************************************************************************************

use data_files\maketable2

merge 1:1 shortnam using data_files\maketable1
* all _merge variables have a value of 3, which means there was a successful merge across the row

* drop variables not necessary
// drop euro1900 excolony cons1 cons90 democ00a cons00a
drop _merge

save data_files\cg-analysis, replace

use data_files\cg-analysis

* 2) theory (summary and dummies) *************************************************************************************
* generate variables needed variables for investigation

// sum

* 15 missing values generated: no information in logpgp95 for those observations, so this is expected (163-148=15)
gen pgp95 = exp(logpgp95)
* 40 missing values generated: no information (163-123=40)
gen hjypl = exp(loghjypl)
gen loglat_abst = log(lat_abst)
gen logavexpr = log(avexpr)


label variable pgp95 "PPP GDP pc in 1995, World Bank"
label variable hjypl "GDP per work, Hall&Jones"
label variable loglat_abst "log Abs(latitude of capital)/90"
label variable logavexpr "log average protection against expropriation risk"

* for readability of variables - y variables on top after shortnam, then doubles, then dummies
order shortnam pgp95 logpgp95 loghjypl hjypl extmort4 logem4 lat_abst loglat_abst avexpr logavexpr africa asia other 

sum

save data_files\cg-analysis, replace

* 3) relevant plots ***************************************************************************************************

* histograms **********************************************************************************************************

twoway histogram pgp95 || kdensity pgp95, title("`: var label pgp95'")
graph export graphs\graph-histogram-pgp95.png, replace
twoway histogram logpgp95 || kdensity logpgp95, title("`: var label logpgp95'")
graph export graphs\graph-histogram-logpgp95.png, replace
* detailed summary of these two variables to look at their skewness - evident from histograms
sum pgp95 logpgp95, detail

twoway histogram hjypl || kdensity hjypl, title("`: var label hjypl'")
graph export graphs\graph-histogram-hjypl.png, replace
twoway histogram loghjypl || kdensity loghjypl, title("`: var label loghjypl'")
graph export graphs\graph-histogram-loghjypl.png, replace
* detailed summary of these two variables to look at their skewness
sum hjypl loghjypl, detail

twoway histogram extmort4 || kdensity extmort4, title("`: var label extmort4'")
graph export graphs\graph-histogram-extmort4.png, replace
twoway histogram logem4 || kdensity logem4, title("`: var label logem4'")
graph export graphs\graph-histogram-logem4.png, replace
sum extmort4 logem4, detail

* clearly log transformation does not improve this variable's distribution
twoway histogram lat_abst || kdensity lat_abst, title("`: var label lat_abst'")
graph export graphs\graph-histogram-lat_abst.png, replace
twoway histogram loglat_abst || kdensity loglat_abst, title("`: var label loglat_abst'")
graph export graphs\graph-histogram-loghjypl.png, replace
sum lat_abst loglat_abst, detail

* clearly log transformation does not improve this variable's distribution
twoway histogram avexpr || kdensity avexpr, title("`: var label avexpr'")
graph export graphs\graph-histogram-avexpr.png, replace
twoway histogram logavexpr || kdensity logavexpr, title("`: var label logavexpr'")
graph export graphs\graph-histogram-logavexpr.png, replace
sum avexpr logavexpr, detail

* scatterplots ********************************************************************************************************

* set 1: with logpgp95 as indep/response variable
* Question: do we look at the fits when not logged? I don't think it's necessary, because we transform based on histograms. Fits look better with transformed variables
* Question: will we look at both indep variables going forward, or pick one? Perhaps logpgp95 since it has more observations
twoway scatter logpgp95 logem4 || lfit logpgp95 logem4
graph export graphs\graph_logem4-vs-logpgp95.png, replace

twoway scatter logpgp95 lat_abst || lfit logpgp95 lat_abst
graph export graphs\graph_lat_abst-vs-logpgp95.png, replace

twoway scatter logpgp95 avexpr || lfit logpgp95 avexpr
graph export graphs\graph_avexpr-vs-logpgp95.png, replace

* set 2: with loghjypl as indep/repsonse variable
twoway scatter loghjypl logem4 || lfit loghjypl logem4
graph export graphs\graph_logem4-vs-loghjypl.png, replace

twoway scatter loghjypl lat_abst || lfit loghjypl lat_abst
graph export graphs\graph_lat_abst-vs-loghjypl.png, replace

twoway scatter loghjypl avexpr || lfit loghjypl avexpr
graph export graphs\graph_avexpr-vs-loghjypl.png, replace

* 4) first estimation *************************************************************************************************

* regression-1 (coincides with name of png in figures)
reg logpgp95 logem4 lat_abst avexpr

* outliers

* influencial points

* 5) tests and corrections ********************************************************************************************

* tests for heteroskedasticity

// reg
// estat hettest, rhs



// ssc install whitetst
// whitetst

// reg with robust

* variable selection

* endogeneity

* instrumental variables

* 6) final model ******************************************************************************************************

* reg

* 7) import recent GDP figures ****************************************************************************************


clear
	
import excel "data_files\Data_Extract_From_World_Development_Indicators.xlsx", sheet("Data") firstrow clear
	
drop SeriesName SeriesCode CountryName
drop if CountryCode == ""

rename CountryCode shortnam
// drop if shortnam == ""

merge 1:1 shortnam using data_files\cg-analysis
* many mismatches - read up on how to identify them here: https://www.princeton.edu/~otorres/Merge101.pdf
* will need to look into this