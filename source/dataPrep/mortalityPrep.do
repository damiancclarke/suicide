/* mortalityPrep.do v0.00        damiancclarke             yyyy-mm-dd:2016-07-26
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

Generate data on suicides using ICD 10 codes.

Note: automatically download off NBER (unix shell only):
for i in {1959..1989};
do echo "downloading mortality file $i";
wget "http://www.nber.org/mortality/$i/mort$i.dta.zip";
unzip mort$i.dta.zip;
rm mort$i.dta.zip;
done

Note: ICD codes have the following mapping to mortality files:
ICD 7  -- 1959-1967
ICD 8  -- 1968-1978
ICD 9  -- 1979-1988
ICD 10 -- 

Note: 1972, 1981 and 1982 50% for some states [CHECK DCC]
*/

vers 11.2
clear all
set more off
cap log close

*-------------------------------------------------------------------------------
*--- (1) globals and locals
*-------------------------------------------------------------------------------
global DAT "~/database/NVSS/Mortality/dta/"
global OUT "~/investigacion/2016/suicide/"
global GEO "~/investigacion/2016/suicide/data/geography/"

cap mkdir "$OUT/log/"
cap mkdir "$OUT/results/"
cap mkdir "$OUT/results/descriptives/"
cap mkdir "$OUT/data/"

log using "$OUT/log/mortalityPrep.txt", text replace

*-------------------------------------------------------------------------------
*--- (2) Generate yearly sheets of suicides only at micro level
*-------------------------------------------------------------------------------
local files1a
foreach year of numlist 1959(1)1961 {
    use "$DAT/mort`year'", clear
    gen suicide = ccr59==58
    tab suicide
    keep if suicide==1
    keep datayear monthdth rectype restatus stateoc countyoc staters countyrs /*
    */   popsize race sex age marital nativity stbirth ucod 

    gen statecheck   = substr(countyoc,1,2)
    replace countyoc = substr(countyoc,3,2)
    destring countyoc, replace
    destring stateoc, replace
    destring statecheck, replace
    
    replace countyoc=countyoc+99 if statecheck==61
    replace countyoc=countyoc+99 if statecheck==63
    replace countyoc=countyoc+99 if statecheck==65
    replace countyoc=countyoc+99 if statecheck==67
    replace countyoc=countyoc+99 if statecheck==69
    replace countyoc=countyoc+100 if statecheck==71
    replace countyoc=countyoc+200 if statecheck==72
    replace countyoc=countyoc+99 if statecheck==74
    replace countyoc=127 if countyoc==61&statecheck==73
    replace countyoc=117 if countyoc==64&statecheck==73
    replace countyoc=128 if countyoc==76&statecheck==73
    replace countyoc=118 if countyoc==125&statecheck==74
    
    
    tempfile y`year'
    save `y`year''
    local files1a `files1a' `y`year''
}

local files1b
foreach year of numlist 1962(1)1963 {
    use "$DAT/mort`year'", clear
    gen suicide = ccr60==58
    tab suicide
    keep if suicide==1
    keep datayear monthdth daydth rectype restatus stateoc countyoc staters  /*
    */   countyrs popsize race sex age nativity stbirth ucod 

    replace countyoc = substr(countyoc,3,3)
    destring countyoc, replace
    destring stateoc, replace
    
    tempfile y`year'
    save `y`year''
    local files1b `files1b' `y`year''
}

foreach year of numlist 1964(1)1967 {
    use "$DAT/mort`year'", clear
    gen suicide = ccr60==58
    tab suicide
    keep if suicide==1
    keep datayear monthdth daydth rectype restatus stateoc countyoc staters  /*
    */   countyrs popsize race sex age ucod 

    replace countyoc = substr(countyoc,3,3)
    destring countyoc, replace
    destring stateoc, replace
    
    tempfile y`year'
    save `y`year''

    local files1b `files1b' `y`year''
}

local files2
foreach year of numlist 1968(1)1978 {
    use "$DAT/mort`year'", clear
    if `year'==1972 expand 2
    gen suicide = ucr69==790
    tab suicide
    keep if suicide==1
    replace datayear=`year'
    keep datayear monthdth rectype restatus stateoc countyoc staters countyrs  /*
*/   popsize race sex age ucod 

    replace countyoc = substr(countyoc,3,3)
    destring countyoc, replace
    destring stateoc, replace

    tempfile y`year'
    save `y`year''

    local files2 `files2' `y`year''
}


foreach year of numlist 1979(1)1981 {
    dis "`year'"
    use "$DAT/mort`year'", clear
    gen suicide = ucr72==820
    tab suicide
    keep if suicide==1
    replace datayear=`year'
    keep datayear monthdth daydth rectype restatus stateoc countyoc staters /*
    */   countyrs popsize race sex age ucod statebth
    replace countyoc = substr(countyoc,3,3)
    destring countyoc, replace
    destring stateoc, replace
    
    tempfile y`year'
    save `y`year''

    local files2 `files2' `y`year''
}

local files3
foreach year of numlist 1982(1)1988 {
    dis "`year'"
    use "$DAT/mort`year'", clear
    gen suicide = ucr72==820
    tab suicide
    keep if suicide==1
    replace datayear=`year'
    keep datayear monthdth daydth rectype restatus stateoc countyoc staters /*
    */   countyrs popsize race sex age ucod statebth 
    if `year'<1988 {
        replace countyoc = substr(countyoc,3,3)
        destring countyoc, replace
        destring stateoc, replace
    }
    else {
        replace countyoc = countyoc-(floor(countyoc/1000)*1000)
    }
    tempfile y`year'
    save `y`year''

    local files3 `files3' `y`year''
}

local files4
foreach year of numlist 1989(1)1993 {
    dis "`year'"
    use "$DAT/mort`year'", clear
    gen suicide = ucr72==820
    tab suicide
    keep if suicide==1
    replace datayear=`year'
    keep datayear monthdth weekday rectype restatus stateoc countyoc staters /*
    */   countyrs popsize race age educ ucod statebth

    replace countyoc = substr(countyoc , -3,.)
    destring countyoc, replace
    destring stateoc, replace

    tempfile y`year'
    save `y`year''

    local files4 `files4' `y`year''
}

local files5
foreach year of numlist 1994(1)1996 1998 1999 2001 2002 {
    dis "`year'"
    use "$DAT/mort`year'", clear
    if `year'<1999 {
        gen suicide = ucr72==820
    }
    else {
        gen suicide = ucr39==40
    }
    tab suicide
    keep if suicide==1
    cap gen datayear=`year'
    replace datayear=`year'

    cap rename statbth statebth
    keep datayear monthdth weekday rectype restatus stateoc countyoc staters /*
    */   countyrs popsize race age educ ucod statebth

    replace countyoc = substr(countyoc , -3,.)
    destring countyoc, replace
    destring stateoc, replace

    tempfile y`year'
    save `y`year''

    local files5 `files5' `y`year''
}

use "$DAT/mort2000", clear
gen suicide = ucr39==40
keep if suicide==1
gen datayear=2000
rename statbth statebth
replace countyoc = substr(countyoc , -3,.)
destring countyoc, replace
destring stateoc, replace
keep datayear monthdth weekday rectype restatus stateoc countyoc staters /*
*/   countyrs popsize race age educ ucod statebth
tempfile y2000
save `y2000'


local files6
foreach year of numlist 2003(1)2009 2011 2012 2014 {
    dis "`year'"
    use "$DAT/mort`year'", clear
    gen suicide = ucr39==40
    tab suicide
    keep if suicide==1
    gen datayear=`year'

    rename statbth statebth
    cap gen rectype=1
    
    keep datayear monthdth weekday rectype restatus stateoc countyoc staters /*
    */   countyrs popsize race age educ* ucod statebth

    replace countyoc = substr(countyoc , -3,.)
    destring countyoc, replace
    destring stateoc, replace

    tempfile y`year'
    save `y`year''

    local files6 `files6' `y`year''
}

*-------------------------------------------------------------------------------
*--- (3) Append to merge with FIPS
*-------------------------------------------------------------------------------
clear
append using `files1a', force
merge m:1 stateoc countyoc using "$GEO/nchs2fips_county1959-1961.dta", force
drop if _merge==2
tempfile group0
save `group0'


clear
append using `files1b', force
merge m:1 stateoc countyoc using "$GEO/nchs2fips_county1962-1967.dta", force
drop if _merge==2
tempfile group1
save `group1'


clear
append using `files2', force
merge m:1 stateoc countyoc using "$GEO/nchs2fips_county1968-1978.dta", force
drop if _merge==2
tempfile group2
save `group2'

clear
append using `files3', force
merge m:1 stateoc countyoc using "$GEO/nchs2fips_county1982-1988.dta", force
drop if _merge==2
tempfile group3
save `group3'

clear
append using `files4', force
merge m:1 stateoc countyoc using "$GEO/nchs2fips_county1989-1993.dta", force
drop if _merge==2
tempfile group4
save `group4'

clear
append using `files5', force
merge m:1 stateoc countyoc using "$GEO/nchs2fips_county1994-2002.dta", force
drop if _merge==2
tempfile group5
save `group5'

clear
use `y2000'
merge m:1 stateoc countyoc using "$GEO/nchs2fips_county2000-2000.dta", force
drop if _merge==2
tempfile group6
save `group6'

clear
append using `files6', force
merge m:1 stateoc countyoc using "$GEO/nchs2fips_county2003-2014.dta", force
drop if _merge==2


append using `group1' `group0' `group2' `group3' `group4' `group5' `group6', force

*-------------------------------------------------------------------------------
*--- (4) Save microdata
*-------------------------------------------------------------------------------
lab dat "All suicides: 1959-2014"
save "$OUT/data/suicides/suicideMicrodata_1959-2014", replace

