# mmef_econ-proj

# step 1
# a) run gfid-variables-to-keep.do
# b) gfid-data-variables.xlsx - update 'Variable selection' sheet if necessary
# c) select variables to keep using boolean and filter on those to keep
# d) copy to 'Keep list' sheet in a row
# e) copy list to gfid-stats-data.do file as parameters to keep command. Step 1 e) given as comment

# step 2
# a) run gfid-stats-data.do file, which will create three files (one for each year for which data is available) using just the variables from step 1 e)

# step 3 - actual statistical analysis for this project is performed here. Repeat steps 1 and 2 as needed to create the necessary .dta files.
# a) run the analysis and regression in remaining gfid-stats-analysis.do file

