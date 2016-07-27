/* mortalityPrep.do v0.00        damiancclarke             yyyy-mm-dd:2016-07-26
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

Generate data on suicides using ICD 10 codes.

Note: automatically download of NBER (unix shell only):
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
*--- (2a) Generate geographic cross-walks
*-------------------------------------------------------------------------------
use "$GEO/nchs2fips_county1990.dta"


*-------------------------------------------------------------------------------
*--- (2b) Generate yearly sheets of suicides only at micro level
*-------------------------------------------------------------------------------
local files
foreach year of numlist 1959(1)1961 {
    use "$DAT/mort`year'", clear
    gen suicide = ccr59==58
    tab suicide
    keep if suicide==1
    keep datayear monthdth rectype restatus stateoc countyoc staters countyrs /*
    */   popsize race sex age marital nativity stbirth ucod 

    replace countyoc = substr(countyoc,3,2)
    destring countyoc, replace
    destring stateoc, replace
    
    tempfile y`year'
    save `y`year''
    local files `files' `y`year''
}

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
    local files `files' `y`year''
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

    local files `files' `y`year''
}

foreach year of numlist 1968(1)1978 {
    use "$DAT/mort`year'", clear
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

    local files `files' `y`year''
}


foreach year of numlist 1979(1)1988 {
    dis "`year'"
    use "$DAT/mort`year'", clear
    gen suicide = ucr72==820
    tab suicide
    keep if suicide==1
    replace datayear=`year'
    keep datayear monthdth daydth rectype restatus stateoc countyoc staters /*
    */   countyrs popsize race sex age ucod 
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

    local files `files' `y`year''
}

clear
append using `files', force
merge m:1 stateoc countyoc using "$GEO/nchs2fips_county1990.dta", force
drop if _merge==2

*-------------------------------------------------------------------------------
*--- (3) Save microdata
*-------------------------------------------------------------------------------
lab dat "All suicides: 1959-1988"
save "$OUT/data/suicideMicrodata_1959-1988"

