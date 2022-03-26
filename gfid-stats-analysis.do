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

sum

* save all possible scatters with fitted line
// foreach i of numlist 5/17 {
// 	twoway scatter y x`i' || lfit y x`i'
// 	graph export graphs\graph-y-vs-x`i'.png, replace
// }

* scatter plots and fitted lines (y vs doubles)

twoway scatter y x5 || lfit y x5

twoway scatter y x6 || lfit y x6

twoway scatter y x7 || lfit y x7

twoway scatter y x8 || lfit y x8

twoway scatter y x9 || lfit y x9

twoway scatter y x10 || lfit y x10

twoway scatter y x11 || lfit y x11

twoway scatter y x12 || lfit y x12

twoway scatter y x13 || lfit y x13

twoway scatter y x14 || lfit y x14

twoway scatter y x15 || lfit y x15

twoway scatter y x16 || lfit y x16

twoway scatter y x17 || lfit y x17

* no loop for histograms as difficult to display variable label in loop
* histograms w/ variable label as title
twoway histogram y || kdensity y, title("`: var label y'")
// graph export graphs\graph-histogram-y.png

twoway histogram x5 || kdensity x5, title("`: var label x5'")
// graph export graphs\graph-histogram-x5.png

twoway histogram x6  || kdensity x6, title("`: var label x6'") 
// graph export graphs\graph-histogram-x6.png

twoway histogram x7  || kdensity x7, title("`: var label x7'") 
// graph export graphs\graph-histogram-x7.png

twoway histogram x8  || kdensity x8, title("`: var label x8'") 
// graph export graphs\graph-histogram-x8.png

twoway histogram x9  || kdensity x9, title("`: var label x9'") 
// graph export graphs\graph-histogram-x9.png

twoway histogram x10 || kdensity x10, title("`: var label x10'")
// graph export graphs\graph-histogram-x10.png

twoway histogram x11 || kdensity x11, title("`: var label x11'")
// graph export graphs\graph-histogram-x11.png

twoway histogram x12 || kdensity x12, title("`: var label x12'")
// graph export graphs\graph-histogram-x12.png

twoway histogram x13 || kdensity x13, title("`: var label x13'")
// graph export graphs\graph-histogram-x13.png

* no data availabel at all for x14 - paid school fees in the past year
twoway histogram x14 || kdensity x14, title("`: var label x14'")
// graph export graphs\graph-histogram-x14.png

twoway histogram x15 || kdensity x15, title("`: var label x15'")
// graph export graphs\graph-histogram-x15.png

twoway histogram x16 || kdensity x16, title("`: var label x16'")
// graph export graphs\graph-histogram-x16.png

twoway histogram x17 || kdensity x17, title("`: var label x17'")
// graph export graphs\graph-histogram-x17.png



* 3) dummy variable creation for world region and income level ********************************************************