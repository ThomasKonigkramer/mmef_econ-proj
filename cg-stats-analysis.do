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

save data_files\cg-analysis, replace

* 2) theory (summary and dummies) *************************************************************************************
* generate variables needed variables for investigation

sum

gen pgp95 = exp(logpgp95)
* 15 missing values generated: no information in logpgp95 for those observations, so this is expected (163-148=15)
gen hjypl = exp(loghjypl)
* 40 missing values generated: no information (163-123=40)

* for readability of variables - y variables on top after shortnam
order shortnam pgp95 logpgp95 loghjypl hjypl


* 3) relevant plots ***************************************************************************************************

* histograms
twoway histogram pgp95 || kdensity pgp95, title("`: var label pgp95'")
// graph export graphs\graph-histogram-pgp95.png
twoway histogram logpgp95 || kdensity logpgp95, title("`: var label logpgp95'")
// graph export graphs\graph-histogram-logpgp95.png
* detailed summary of these two variables to look at their skewness - evident from histograms
sum pgp95 logpgp95, detail

twoway histogram hjypl || kdensity hjypl, title("`: var label hjypl'")
// graph export graphs\graph-histogram-hjypl.png
twoway histogram loghjypl || kdensity loghjypl, title("`: var label loghjypl'")
// graph export graphs\graph-histogram-loghjypl.png
* detailed summary of these two variables to look at their skewness
sum hjypl loghjypl, detail












* scatterplots of variables




* scatterplots
twoway scatter loggdp risk || lfit loggdp risk
// graph export graphs\graph_risk-vs-loggdp.png, replace

* histograms
twoway histogram loggdp || kdensity loggdp, title("`: var label loggdp'")
// graph export graphs\graph-histogram-y.png

* 4) first estimation *************************************************************************************************

* reg

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