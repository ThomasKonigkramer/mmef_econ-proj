/* 
Title: 		gfid - global financial inclusion analysis

Authors		Xiao Jiang
			Sukanya Mukherjee
			Thomas Konigkramer			
			
Date		23 March 2022

Sections	1) use data - created in 'gfid-stata-data.do'
			2) initial analysis
			3) dummy variable creation for world region and income level
			4) 
			
*/

* change working directory (pwd) as needed
cd "C:\Users\ThomasKönigkrämer\Desktop\MMEF_2021\Econometrics\mmef_econ-project"

* 1) use imported data ************************************************************************************************

* only looking at year (2011, 2014 or 2017) as defined in local variable 'year' below
local year = 2017
display `year'
use data_files\gfid-data-`year'

* 2) initial analysis *************************************************************************************************

sum y x2 x3 x4 x5 x6 x7

twoway scatter y x5 || lfit y x5, title("y vs financial institution account")
graph export graphs\graph-1_`year'.png, replace


* 3) dummy variable creation for world region and income level ********************************************************