/* 
Title: 		econometrics midterm/project

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
cd "C:\Users\ThomasKönigkrämer\Desktop\MMEF_2021\Econometrics\mmef_econ-proj"

* 1) use, save data ***************************************************************************************************

use data_files\dataset

save data_files\econ-proj, replace

* 2) theory (summary and dummies) *************************************************************************************

sum

* 3) relevant plots ***************************************************************************************************

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



* variable selection

* endogeneity

* instrumental variables

* 6) final model ******************************************************************************************************

* reg