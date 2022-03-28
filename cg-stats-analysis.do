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
clear

cd "C:\Users\ThomasKönigkrämer\Desktop\MMEF_2021\Econometrics\mmef_econ-proj"
// log using maketable1, replace
* 1) use, save data ***************************************************************************************************

use data_files\maketable1

// use data_files\AJR

* drop variables not necessary
// drop slave

save data_files\testing-here, replace

* 2) theory (summary and dummies) *************************************************************************************
* generate variables needed (exponential)


sum

* investigate joining tables 1 and 2 on country (otherwise just use 2)

/* dummies already exist for the following variables:
>> source of mortality rate
	>> campaign
	>> source
	>> campaignsj
	>> caompaignsj2
	

>> slave

>> region
	>> neoeuro
	>> asia
	>> africa
	>> wandcafrica
	>> other
	
>> contested observations in west and central africa
*/

* 3) relevant plots ***************************************************************************************************

* histo of variables gdps(two different), latitude, expropriation and logs

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