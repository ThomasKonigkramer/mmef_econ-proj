/* 
Title: 			gfid - variables selection process

Authors			Xiao Jiang
				Sukanya Mukherjee
				Thomas Konigkramer			
			
Date			23 March 2022

Description		Used just to create "gfid-data-variables.xlsx" file for variable selection process
				Sheet 'Variables' created with variable names as header
				Sheet 'Labels' created with variable names as header
				Additionally, the workbook contains two other sheets that are treated separately:
					Sheet 'Variable selection' contains a list of the variable names and labels, which are selected using a boolean identifier
					Sheet 'Keep list' contains a row of all the variable names to keep, copied from the 'Variable selection' sheet using a filter. This row is used as the 'keep' command parameters in 'gfid-stats-data.do'
			
*/

* change working directory (pwd) as needed
cd "C:\Users\ThomasKönigkrämer\Desktop\MMEF_2021\Econometrics\mmef_econ-project"

* used initially to determine relevant variables for analysis
clear 
import excel "data_files\Global-Findex-Database.xlsx", sheet("Data") firstrow clear
label variable A "Year"
label variable B "Country code"
label variable C "Country name"
label variable D "World region"
label variable E "Income level"
save data_files\gfid-data-original, replace
export excel "data_files\gfid-data-variables.xlsx", sheet("Variables", replace) firstrow(variables)  
export excel "data_files\gfid-data-variables.xlsx", sheet("Labels", replace) firstrow(varlabels) 