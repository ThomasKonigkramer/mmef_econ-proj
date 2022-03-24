/* 
Title: 			gfid - global financial inclusion 'data-year'

Authors			Xiao Jiang
				Sukanya Mukherjee
				Thomas Konigkramer			
			
Date			23 March 2022

Description		This .do creates 3 dta files for the three years of data that were collected, namely 2011, 2014 and 2017.
				Various data points are dropped, as they are aggregated data, and not country-specific as we require for our analysis.
				Variables are also dropped so that we only include those necessary for our analysis.

Sections		1) import, save and initial modifications to data

*/

* change working directory (pwd) as needed
cd "C:\Users\ThomasKönigkrämer\Desktop\MMEF_2021\Econometrics\mmef_econ-project"

* 1) import, save and initial modifications to data *******************************************************************

* will loop to create 3 different dta files for the 3 different years data was collected
local year_list 2011 2014 2017
foreach year in `year_list'{
	
	clear
	
	import excel "data_files\Global-Findex-Database.xlsx", sheet("Data") firstrow clear

	* suggestion for y
	order Accountage15, first
	
	* step 1 e) keep only listed variables - see 'gfid-variables-to-keep.do'
	keep A	C	D	E	Accountage15	Financialinstitutionaccount	MainmodeofwithdrawalATM	Mainmodeofwithdrawalbankte
	
	* adding in missing labels
	label variable A "Year"
// 	label variable B "Country code"
	label variable C "Country name"
	label variable D "World region"
	label variable E "Income level"
	
	* look only at year (2011, 2014 or 2017) as defined in loop
	drop if A != `year'

	* remove data points where D (world region) is empty - this coincides with grouped countries which we don't want as data points
	drop if D == ""
	
	* rename tedious variable names - labels are descriptive enough
	ds
	local vars `r(varlist)'
	local j = 0
	foreach i in `vars' {
		rename `i' x`j'
		local j = `j' + 1
	}

	rename x0 y
	
	* saving dta table
	save data_files\gfid-data-`year', replace
	
}