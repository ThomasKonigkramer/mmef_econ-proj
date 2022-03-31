use "/Users/jiangxiao/Downloads/maketable2.dta"



merge 1:1 shortnam using "/Users/jiangxiao/Downloads/maketable1/maketable1.dta"

* all _merge variables have a value of 3, which means there was a successful merge across the row

* drop variables not necessary (_merge interferes with future merges)
// drop euro1900 excolony cons1 cons90 democ00a cons00a
// drop _merge

save data_files\cg-analysis, replace

use data_files\cg-analysis

* 2) theory (summary and dummies) *************************************************************************************
* generate variables needed variables for investigation

// sum

* 15 missing values generated: no information in logpgp95 for those observations, so this is expected (163-148=15)
gen pgp95 = exp(logpgp95)
* 40 missing values generated: no information (163-123=40)
// gen hjypl = exp(loghjypl)
gen loglat_abst = log(lat_abst)
gen logavexpr = log(avexpr)

label variable pgp95 "PPP GDP pc in 1995"
// label variable hjypl "GDP per work, Hall&Jones"
label variable loglat_abst "log Abs(latitude of capital)/90"
label variable logavexpr "log average protection against expropriation risk"
gen neoeuro = 0
replace neoeuro = 1 if shortnam == "AUS"
replace neoeuro = 1 if shortnam == "CAN"
replace neoeuro = 1 if shortnam == "NZL"
replace neoeuro = 1 if shortnam == "USA"

* other country dummy already exists - 1 for AUS, FJI, MLT, NZL. I think we should remove this unless we have justification to cluster these countries

* for readability of variables - y variables on top after shortnam, then doubles, then dummies
order shortnam pgp95 logpgp95 loghjypl extmort4 logem4 lat_abst loglat_abst avexpr logavexpr africa asia neoeuro other 
sum

save data_files\cg-analysis, replace
twoway histogram pgp95, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity pgp95, lcolor (red) lpattern(dash)  title("`: var label pgp95'") note(American Economic Review 91 December 2001: pp. 1369-1401.)
graph export graphs\graph-histogram-pgp95.png, replace
twoway histogram logpgp95, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity logpgp95, lcolor (red) lpattern(dash)  title("`: var label logpgp95'") note(American Economic Review 91 December 2001: pp. 1369-1401.)
graph export graphs\graph-histogram-logpgp95.png, replace
* detailed summary of these two variables to look at their skewness - evident from histograms
sum pgp95 logpgp95, detail

// twoway histogram hjypl || kdensity hjypl, title("`: var label hjypl'")
// graph export graphs\graph-histogram-hjypl.png, replace
// twoway histogram loghjypl || kdensity loghjypl, title("`: var label loghjypl'")
// graph export graphs\graph-histogram-loghjypl.png, replace
// * detailed summary of these two variables to look at their skewness
// sum hjypl loghjypl, detail

twoway histogram extmort4, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity extmort4, lcolor (red) lpattern(dash) title("`: var label extmort4'") note(American Economic Review 91 December 2001: pp. 1369-1401.)
graph export graphs\graph-histogram-extmort4.png, replace
twoway histogram logem4, lcolor(black) fcolor(pink%5) graphregion(fcolor(white))  || kdensity logem4, lcolor (red) lpattern(dash) title("`: var label logem4'") note(American Economic Review 91 December 2001: pp. 1369-1401.)
graph export graphs\graph-histogram-logem4.png, replace
sum extmort4 logem4, detail

* clearly log transformation does not improve this variable's distribution
twoway histogram lat_abst, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity lat_abst, lcolor (red) lpattern(dash) title("`: var label lat_abst'")  note(American Economic Review 91 December 2001: pp. 1369-1401.)
graph export graphs\graph-histogram-lat_abst.png, replace
twoway histogram loglat_abst, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity loglat_abst, lcolor (red) lpattern(dash) title("`: var label loglat_abst'")  note(American Economic Review 91 December 2001: pp. 1369-1401.)
graph export graphs\graph-histogram-loghjypl.png, replace
sum lat_abst loglat_abst, detail

* clearly log transformation does not improve this variable's distribution
twoway histogram avexpr, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity avexpr, lcolor (red) lpattern(dash) title("`: var label avexpr'") note(American Economic Review 91 December 2001: pp. 1369-1401.)
graph export graphs\graph-histogram-avexpr.png, replace
twoway histogram logavexpr, lcolor(black) fcolor(pink%5) graphregion(fcolor(white)) || kdensity logavexpr, lcolor (red) lpattern(dash) title("`: var label logavexpr'") note(American Economic Review 91 December 2001: pp. 1369-1401.)
graph export graphs\graph-histogram-logavexpr.png, replace
sum avexpr logavexpr, detail

* scatterplots ********************************************************************************************************

* set 1: with logpgp95 as indep/response variable
* justification for picking logpgp95: no. of observations available.
// twoway scatter logpgp95 logem4 || lfit logpgp95 logem4, saving(graph_logem4-vs-logpgp95)
twoway scatter logpgp95 logem4, mcolor(pink%25) || lfit logpgp95 logem4, lcolor (red) title("Effect of settler mortality on PPP GDP pc in 1995") ytitle(PPP GDP pc in 1995) xtitle(Settler mortality) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big) note(American Economic Review 91 December 2001: pp. 1369-1401.) 
graph export graphs\graph_logem4-vs-logpgp95.png, replace

twoway scatter logpgp95 lat_abst, mcolor(pink%25) || lfit logpgp95 lat_abst, lcolor (red%60) title("Effect of latitude of capital on PPP GDP pc in 1995") ytitle(PPP GDP pc in 1995) xtitle(Latitude of Capital) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big) note(American Economic Review 91 December 2001: pp. 1369-1401.) 
graph export graphs\graph_lat_abst-vs-logpgp95.png, replace

// graph combine graph_logem4-vs-logpgp95.gph graph_lat_abst-vs-logpgp95.gph

twoway scatter logpgp95 avexpr, mcolor(pink%25) || lfit logpgp95 avexpr, lcolor (red) title("Effect of avexpr on PPP GDP pc in 1995")  ytitle(PPP GDP pc in 1995) xtitle(Averagre protection against expropriation risk) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big) note(American Economic Review 91 December 2001: pp. 1369-1401.) 
graph export graphs\graph_avexpr-vs-logpgp95.png, replace

* set 2: with loghjypl as indep/repsonse variable
twoway scatter loghjypl logem4, mcolor(pink%25) || lfit loghjypl logem4, lcolor (red) title("Effect of settler mortality on GDP per worker in 1995")  ytitle(GDP per worker) xtitle(Settler mortality) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big) note(American Economic Review 91 December 2001: pp. 1369-1401.) 
graph export graphs\graph_logem4-vs-loghjypl.png, replace

twoway scatter loghjypl lat_abst,  mcolor(pink%25) || lfit loghjypl lat_abst, lcolor (red) title("Effect of latitude of capital on GDP per worker in 1995")  ytitle(GDP per worker) xtitle(latitude of capital) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big) note(American Economic Review 91 December 2001: pp. 1369-1401.) 
graph export graphs\graph_lat_abst-vs-loghjypl.png, replace

twoway scatter loghjypl avexpr,  mcolor(pink%25) || lfit loghjypl avexpr, lcolor (red) title("Effect of avexpr on GDP per worker in 1995")  ytitle(GDP per worker) xtitle(Averagre protection against expropriation risk) lcolor(red%60) graphregion(fcolor(white)) legend(off) lwidth(big) note(American Economic Review 91 December 2001: pp. 1369-1401.) 
graph export graphs\graph_avexpr-vs-loghjypl.png, replace

* 4) first estimation *************************************************************************************************

* variable selection, i.e. obtaining the regression we want ***********************************************************
* regression-1.png (coincides with name of png in figures)
reg logpgp95 logem4 lat_abst avexpr

* we see that lat_abst is not significant, but there is some theory that says it would be. Perhaps clustering various similar countries will improve the significants.
* add motivation for our clusters

* regression-2.png
reg logpgp95 logem4 lat_abst avexpr africa asia neoeuro
* lat_abs even less significant and neoeuro also insignficant

* regression-3.png: dropped neoeuro since insign
reg logpgp95 logem4 lat_abst avexpr africa asia

* regression-4.png: dropped lat_abst since was still insign. Including neoeuro because interesting. Neoeuro proves to be insign.
reg logpgp95 logem4 avexpr africa asia neoeuro

* regression-5.png: only sign. variables - this is the one we want
reg logpgp95 logem4 avexpr africa asia

* regression-6.png: sign. with no dummies - just for interest
reg logpgp95 logem4 avexpr

* final regression:
reg logpgp95 logem4 avexpr africa asia

* 5) tests and corrections ********************************************************************************************

* tests for heteroskedasticity ****************************************************************************************

*estat-hettest.png
estat hettest, rhs

* needs to be run somewhere else - not working on Tom's computer - have no screenshots post this
ssc install whitetst
whitetst

* all the same as before, but no adjusted R^2
reg logpgp95 logem4 avexpr africa asia, robust

* outliers
rvfplot, mlabel(shortnam) graphregion(fcolor(white)) note(American Economic Review 91 December 2001: pp. 1369-1401.) title(PPP GDP pc in 1995)


