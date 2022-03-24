/* 
Title: 		gfid - global financial inclusion

Authors		Xiao Jiang
			Sukanya Mukherjee
			Thomas Konigkramer			
			
Date		23 March 2022

Sections	1) import, save and initial modifications to data
			2) initial analysis
			3) dummy variable creation for world region and income level
			4) 
			
*/

* change working directory (pwd) as needed
cd "C:\Users\ThomasKönigkrämer\Desktop\MMEF_2021\Econometrics\econ_project"

* 1) import, save and initial modifications to data *******************************************************************

* will loop to create 3 different dta files for the 3 different years data was collected
local year_list 2011 2014 2017
foreach year in `year_list'{
	
	clear
	drop _all
	
	* keep necessary excel file in pwd
	import excel "Global-Findex-Database.xlsx", sheet("Data") firstrow clear

	* suggestion for y
	order Accountage, first

	* rename tedious variable names - labels are descriptive enough
	ds
	local vars `r(varlist)'
	local j = 0
	foreach i in `vars' {
		rename `i' x`j'
		local j = `j' + 1
	}

	rename x0 y

	* adding in missing labels
	label variable x1 "Year"
	label variable x2 "Country code"
	label variable x3 "Country name"
	label variable x4 "World region"
	label variable x5 "Income level"

	* look only at year as defined in loop
	drop if x1 != `year'
	
	* remove data points where x4 (world region) is empty - this coincides with grouped countries which we don't want as data points
	drop if x4 == ""
	
	* saving dta table
	save gfid-data-`year', replace
	
}

* only looking at year (2011, 2014 or 2017) as defined in local variable 'year' below
local year = 2017
display `year'
use gfid-data-`year'

* 2) initial analysis *************************************************************************************************

sum y x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16

twoway scatter y x6 || lfit y x6, title("y vs male")
graph export graph-1_`year'.png, replace


* 3) dummy variable creation for world region and income level ********************************************************