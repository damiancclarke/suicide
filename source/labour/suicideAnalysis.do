/* suicideAnalysis.do v0.00      damiancclarke             yyyy-mm-dd:2016-11-23
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

Examine suicide rates at county levels and how these depend on labour market sho
cks using Bartik IV.

*/

vers 11    
clear all
set more off
cap log close

*-------------------------------------------------------------------------------
*--- (1) globals, locals
*-------------------------------------------------------------------------------
global DAT "~/investigacion/2016/suicide/data"
global OUT "~/investigacion/2016/suicide/results/regressions/labour"
global LOG "~/investigacion/2016/suicide/log"

cap mkdir $OUT

log using "$LOG/graphical.txt", replace text

*-------------------------------------------------------------------------------
*--- (2) Create state cells
*-------------------------------------------------------------------------------
use "$DAT/suicides/suicideMicrodata_1959-1988.dta"
keep if datayear>=1970
drop if fipsco==""
gen suicide = 1
replace suicide = 2 if datayear==1972

collapse (sum) suicide, by(fipsco datayear)
rename datayear year
destring fipsco, gen(fips)
preserve
use "$DAT/population/countyPopulation", clear
replace fips = 36 if fips==36005|fips==36047|fips==36061|fips==36081|fips==36085
collapse (sum) pop*, by(year fips)
tempfile population
save `population'
restore
merge 1:1 fips year using `population'
drop if _merge==1
replace suicide=0 if _merge==2
gen suicideRate = (suicide/pop_total)*100000
expand 4 if fips==36
bys fips year: gen n=_n
replace fips = 36005 if fips==36 & n==1
replace fips = 36047 if fips==36 & n==2
replace fips = 36061 if fips==36 & n==3
replace fips = 36085 if fips==36 & n==4
drop _merge
gen fipsst = floor(fips/1000)
tab fipsst
drop if fipsst==2

rename fips countyfips
merge 1:1 countyfips year using "$DAT/labor/clean_1969_2000_all"
drop if year==1969|year>=1990

**Need to fix VA fips

*-------------------------------------------------------------------------------
*--- (3) Generate employment variables
*-------------------------------------------------------------------------------
#delimit ;
gen pop_total_20_64=pop_total_20_24+pop_total_25_29+pop_total_30_34+
    pop_total_35_39+pop_total_40_44+pop_total_45_49+pop_total_50_54+
    pop_total_55_59+pop_total_60_64;
gen empShare = emptotal_empl/pop_total_20_64;
#delimit cr


