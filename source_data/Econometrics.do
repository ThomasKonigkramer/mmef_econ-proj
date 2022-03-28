* ---------------------------- W1 First Course ----------------------------*

* First steps (comments) 
/*
help regress
sysuse auto, clear
regress mpg weight foreign
*/

* use "/* */" to make a bunch of rows be comments

* load data
use "D:\StataMPData\vietnamdata.dta",clear

* save data in working directory
save vn, replace
* Make a copy of origianl dataset
save vn, replace 

* change your working directory\
cd D:\StataMPData

* describe data
sum total
sum med, detail
** detail will make the description more detailed
** sum represents for summarize, and we can use both sum or summarize
sum med total, detail
** description of med and total coming at the same time

****** key points:
 *basic regression
 *how to use stata 


* -------------------------- W2 Second Course -----------------------------*

sum med total, detail
/* S = E((X-u)^3), Normal Distribution's mean and medium are 0
  Mean > Medium, skewed to the right
  Mean < Medium, skewed to the left 
*/
/* 
  K = E((X-u)^4) Normal Distribution's K = 3
  bigger than 3, more kurtosis
  
*/

/* log(income) could make data more suitable for analysis,
   more "Normal", less extreme
*/
sum med, detail

** Ways of forming different types of graphs of data
* histogram density
histogram total
* curve density
kdensity total 

histogram med
kdensity med

** correlation between different variables, get corr coefficient matrix
corr total med
* sig can make level of significance appear
pwcorr total med, sig

** "twoway scatter with line" graph
*option1 
twoway scatter med total || lfit med total 
*option2
twoway (scatter med total) (lfit med total) 

** generate data using log and check the status of datasets 
gen logtotal = log(total)
sum logtotal,detail
histogram logtotal
kdensity logtotal

gen logmed = log(med+1)
sum logmed,detail
histogram logmed
kdensity logmed

corr logmed logtotal

twoway (scatter logmed logtotal) (lfit logmed logtotal) 
* break one long line in 2 short ones
twoway (scatter logmed logtotal) /*
*/ (lfit logmed logtotal) 

* use condition to construct a more precise line
twoway (scatter logmed logtotal) /*
*/ (lfit logmed logtotal if logmed>0) 


/*
key points:
(i) use log to normalize dataset
(ii) Binary Choice Model (Robit,Logit)
step1:Decision to spend Y1 = 0 or 1
step2:For those who choose Y1 = 1, then decide the value for Y2：regular regression OLS
*/


* How to choose models: using economic theory, common sense, plots



* --------------------------- W2 First Class ----------------------- *

reg logmed logtotal if logmed>0

* -------------------------------------------------------------------
* Anscombe identical regression

drop _all

use "D:\StataMPData\anscombe.dta"
save ac

* regression
reg y1 x1
reg y2 x2
reg y3 x3
reg y4 x4
* plot scatterplot and reg line
twoway (scatter y1 x1) (lfit y1 x1)  // good example
twoway (scatter y2 x2) (lfit y2 x2)  // squared 
twoway (scatter y3 x3) (lfit y3 x3)  // extreme point
twoway (scatter y4 x4) (lfit y4 x4)  // 

* ----------------------------------------------------------------- *
* Various simulations to see the performances of OLS estimators
/********************************************************************/

* 1) Check that OLS estimates are random variables: generate 100 samples of 40 observations

drop _all
clear matrix
set mem 500m
set more off

* Specify initial value of random-number seed
set seed 10101

* Change the following for different sample size N
global numobs "100000" //global numobs &quot;1000&quot;

* Change the following for different number of simulations S
global numsims "100" //global numsims &quot;100&quot;

/* set obs changes the number of observations in the current dataset.  # must be at least as large as the
    current number of observations.  If there are variables in memory, the values of all new observations
    are set to missing */

set obs $numobs     
gen x = invnorm(uniform())
save data1, replace

* The true dgp will be y=2+3x+u (with u a normal), let&#039;s generate this &quot;numsims&quot; times
* Check what will happen eventually if we increase the variance of the error term (invnorm() then 5*invnorm)

forvalues i = 1(1)$numsims {
        generate y`i' = 2 + 3*x + 5*invnorm(uniform())
		}
		
matrix coeff=(0) /* To create a matrix, we have to specify at least its 1st element, that we&#039;ll remove right after */

forvalues i = 1(1)$numsims {
        quietly reg y`i' x
		matrix coeff = (coeff \ _b[x] )
			}
			

save data1, replace

drop _all
svmat coeff  
save tablecoeff , replace
drop if _n==1 /* because the 1st element in the matrix was 0 */

* Check that the slope parameter is a random variable, whose distribution is nicely bell-shaped (=Normal)
hist coeff1
kdensity coeff1

* Check that on average, we get to the true value of the parameter
summarize coeff1

* 2) Check consistency: see what happens when we increase the number of observations 

* Only need to increase numobs to 100&#039;000 to see that the slope parameter departs less and less from the true value
* And right after the first drop _all,
* add a line saying set mem 500m otherwise the resulting dataset will be too big for
* the default setting of Stata
* check that the now the span of values for b is small, highly concentrated around the true value

* 3) See what happens if x is correlated to u

set more off

drop _all

* Specify initial value of random-number seed
set seed 10101

* Change the following for different sample size N
global numobs "1000"

* Change the following for different number of simulations S
global numsims "100"

/* set obs changes the number of observations in the current dataset.  # must be at least as large as the
    current number of observations.  If there are variables in memory, the values of all new observations
    are set to missing */

set obs $numobs     

* The true dgp will be y=2+3x+u, let&#039;s generate this &quot;numsims&quot; times
* Check what will happen eventually if we increase the variance of the error term (invnorm() then 5*invnorm)

matrix coeff=(0) /* To create a matrix, we have to specify at least its 1st element, that we&#039;ll remove right after */

forvalues i = 1(1)$numsims {
		gen u`i' = 5*invnorm(uniform())
		gen x`i'= invnorm(uniform()) + 2*(u`i')
        generate y`i' = 2 + 3*x`i' + u`i'
		quietly reg y`i' x`i'
		matrix coeff = (coeff \ _b[x`i'] )
		drop y`i' x`i'
		}
		
			

save data1, replace

drop _all
svmat coeff  
save tablecoeff , replace
drop if _n==1 /* because the 1st element in the matrix was 0 */

* Check that the slope parameter is a random variable, whose distribution is nicely bell-shaped (=Normal)
kdensity coeff1

* Check that on average, we get to the true value of the parameter
summarize coeff1

* No we don&#039;t: the value we get is 3.5, so the estimator is:
* - biased (what we find on average with small sample size, say 40)
* - inconsistent, i.e. the bias does not go to zero (we still find 3.5 on average even with a very large sample size)


 

</div></pre>

* --------------------- Third Class -----------------------*
* b hat two ways Important
* 
use "D:\StataMPData\vietnamdata.dta",clear
reg logmed logtotal sex age educyr98 farm urban98 hhsize if logmed>0
* std.err.对应V(b)的对角线上的 cov在memory里有但是不是默认显示
lincom sex-0.2
* To check whether sex-0.2 = 0, it's in unrejected area
* it could be explained as linear combination of sex - 0.2 = 0
lincom sex
* To refuse that sex = 0




* --------------------- Fourth Class 2.25 ------------------- *
drop _all

h load

search load

* import csv
clear
import delimited "D:\StataMPData\vietnamdata.csv"
save dcsv, replace
* import xls
import excel "D:\StataMPData\vietnamdata.xls", sheet("vietnamdata") clear
* import xls and make the first column as the name of variables
import excel "D:\StataMPData\vietnamdata.xls", sheet("vietnamdata") firstrow clear
* save data
save d, replace // save in the cureent working directory and d is the name of the file newly saved, if there's already a file with the same name, then using replace
save "D:\StataMPData\Ru\try", replace
cd //change working directory
pwd //checking current working directory

use http://www.stata-press.com/data/kk/anscombe

use d

* modify data
generate old=(age>=65)


** 2 ways of generating a column
*option 1 
gen female=(sex==2)
* a==1 is testing whether a is equal to 1

*option 2
gen fem=1
replace fem=0 if sex==1

*labeling
label variable old "Age 65 plus"
label variable female "Female" 

*more than 2 categories: dummies
h tabulate
tabulate hhsize, gen(dhhsize) 
sum dhhsize*

*generate var with formulate
egen avtotal=mean(total) // if use a function to generate then use egen
gen demean = total-avtotal
save,replace //change the new with the same name
save d1 

* change string to numeric
use dcsv
mean total // will report an error for total is string now
destring total, replace dpcomma

* ------------------------ 3.10 ----------------------------------------

use "D:\StataMPData\cobbdouglas.dta",clear

twoway scatter valueadd labor || lfit valueadd labor 
twoway scatter valueadd capital || lfit valueadd capital

* describe data
sum valueadd
sum labor
sum capital, detail
** detail will make the description more detailed
** sum represents for summarize, and we can use both sum or summarize
sum valueadd labor capital, detail
** description of med and total coming at the same time

histogram valueadd
kdensity valueadd

gen logvalue = log(valueadd)
gen loglabor = log(labor)
gen logcapital = log(capital) 

histogram logvalue
kdensity logvalue

twoway scatter logvalue loglabor || lfit logvalue loglabor 
twoway scatter logvalue logcapital || lfit logvalue logcapital

reg logvalue loglabor logcapital

lincom loglabor - logcapital 
lincom loglabor + logcapital - 1

** 以上自己做 以下为老师做

use "D:\StataMPData\cobbdouglas.dta",clear
save cobdog1, replace

gen logK = log(capital)
gen logL = log(labor)
gen logV = log(valueadd)

sum capital
sum logK

sum labor
sum logL

sum valueadd
sum logV

* histogram or kdensity
histogram valueadd
kdensity valueadd

hist logV
kdensity logV

twoway scatter logV logK || lfit logV logK
twoway scatter logV logL || lfit logV logL


twoway scatter valueadd capital || lfit valueadd capital
twoway scatter valueadd labor || lfit valueadd labor
* we found that the points are too concentrated it depend on only some points by using log

reg logV logK logL
* globally significance
* all of variables are significant

lincom logL + logK - 1
lincom logK - logL
* accepted 

* Another option is to use Fisher
test logK + logL = 1
* accepted
test logK = logL
* 从reg的结果上也可以看出，尽管coefficients of logK and logL 不同，但他们的置信区间是overlapped 则他们仍有可能是相同的
* ------------------------------------------------------
use "D:\StataMPData\duncan.dta",clear

reg prestige income education
* next time outliers and somethingelse, in this case, even though the sample size
* is not that large, but in reality we could not find so many different occupations

 
* --------------------------- 3.11 -----------------------------------
use "D:\StataMPData\vietnamdata.dta",clear
reg logmed logtotal sex age educyr98 farm urban98 hhsize if logmed>0

test farm hhsize // Fisher-test

reg logmed logtotal sex age educyr98 urban98 if logmed>0
* Then there's none 没用的可以剔除的变量
* and adj-R squared not change 


* --------------------------- 3.17 -----------------------------------
* Heteroskedastic
use "D:\StataMPData\duncan.dta",clear

reg prestige income education

twoway scatter prestige income
* 看起来有喇叭状嫌疑
twoway scatter prestige education
// 初步看看有没有异方差

estat hettest, rhs
* estat test ui^2 has linear relation with rhs-(right hand side variables)
* homoskestic

whitetst
* fail to reject

* FGLS doesn't work with small sample size, i.e. in this case

twoway scatter prestige income, mlabel(occupation)
twoway scatter prestige education, mlabel(occupation)

rvfplot, mlabel(occupation)
* 残差大的minister是outlier

predict diag_leverage1, leverage
list diag_leverage1
* outliers testing

gen cond = (occupation=="conductor")
gen eng = (occupation=="RR.engineer")
gen min = (occupation=="minister")

reg prestige income education
reg prestige income education cond eng min
reg prestige income education if (cond == 0 & eng==0 & min == 0)
* leverage


reg prestige income education
predict diag_studres, rstudent
predict prestigehat
twoway scatter diag_studres prestigehat, mlabel(occupation)
* minister & reporter超出了[-2,2] bound

* drop diag_studres 

reg prestige income education
dfbeta 
list _dfbeta_1 _dfbeta_2
* high dubata means that the variable will have large effect on the estimation result , if it is large effect it's better to use dummy variable 
* 6的很高 删除会对bhat造成影响 故最好的方式是用dummy variable

lvr2plot, mlabel(occupation)
* put the leverage and residual in one graph 将leverage和residual放在一个图检视

sum

*------------------------------Hw1--------------------------------
use "D:\StataMPData\wages1",clear

reg wage educ exper

twoway scatter wage educ

twoway scatter wage exper

estat hettest, rhs

whitetst

reg wage educ exper male

* ------------------------------ 3.18 -------------------------------
use "D:\StataMPData\CHIS_2005_Adult.dta",clear

reg nbdoct age

reg nbdoct age latino pacific native asian afro other female pregnant hlth_vgood hlth_fair hlth_good hlth_poor asthma diabetes hbpressure heart arthritis insured mental 

reg wage educ exper
1)impact of gender: wage gap?
2) chow test : behaviors differ b/w genders
use cross product variables

for wage data

24/03

 use "/Users/jiangxiao/Downloads/nbAT.dta"
*(Written by R.              )

sum
*description of the data

reg nbAT prev indus taille idf 
*all significant in 5% level.

ivregress 2sls nbAT (prev=rp pctsy) indus taille idf, first
* 2 stages are included in one line

estat endogenous
* exogeneity test(1)
* 拒绝原假设，is endogeneous

estat overid

ivregress 2sls nbAT (prev=rp pctsy objsecu) indus taille idf, first
* 2 stages are included in one line

estat endogenous
* Hausman test 
* exogeneity test(1)
* 拒绝原假设，is endogeneous

estat overid
* bad instrument they are not exogenous
* sargen test



. use "/Users/jiangxiao/Downloads/wages1.dta"

reg wage educ exper male
v

test male educ male exper male
*chow test testing the group

25/03

use "/Users/jiangxiao/Downloads/panel_bruderl.dta"
help plot
* xtline prefix xt for panel data
sort id time

xtset id time
xtline wage,overlay

*ols
reg wage marr

twoway scatter wage marr || lfit wage marr
* lfit ti linear fit the two variables and|| means to have a line 

tabulate time, gen(t)
* 
reg wage marr t2-t6
*they are not significant we don't need time dummy / drop the one as the reference year.

tabulate id, gen(i)

reg wage marr i1-i4 t2-t6, noconstant
*without constant you can't use r square. time still not significant.



















































