/* populationPrep.do v0.00       damiancclarke             yyyy-mm-dd:2016-07-26
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

Population by county, race and age.

*/

vers 11.2
clear all
set more off
cap log close

*-------------------------------------------------------------------------------
*--- (1) globals and locals
*-------------------------------------------------------------------------------
global DAT "~/investigacion/2016/suicide/data/population/"
global OUT "~/investigacion/2016/suicide/"

log using "$OUT/log/populationPrep.txt", text replace

local p1970 co-asr-7079.csv 
local p1980 PE-02.csv

*-------------------------------------------------------------------------------
*--- (2) Generate full file
*-------------------------------------------------------------------------------
insheet using "$DAT/`p1970'", comma names
reshape wide a*, i(year fips) j(group)
egen pop_total        = rowtotal(a*)
egen pop_black_female = rowtotal(a054-a851104)
egen pop_black_male   = rowtotal(a053-a851103)
egen pop_white_female = rowtotal(a052-a851102)
egen pop_white_male   = rowtotal(a051-a851101)
egen pop_other_female = rowtotal(a056-a851106)
egen pop_other_male   = rowtotal(a055-a851105)
egen pop_total_0_5    = rowtotal(a05*)
egen pop_total_5_9    = rowtotal(a59*)
egen pop_total_10_14  = rowtotal(a1014*)
egen pop_total_15_19  = rowtotal(a1519*)
egen pop_total_20_24  = rowtotal(a2024*)
egen pop_total_25_29  = rowtotal(a2529*)
egen pop_total_30_34  = rowtotal(a3034*)
egen pop_total_35_39  = rowtotal(a3539*)
egen pop_total_40_44  = rowtotal(a4044*)
egen pop_total_45_49  = rowtotal(a4549*)
egen pop_total_50_54  = rowtotal(a5054*)
egen pop_total_55_59  = rowtotal(a5559*)
egen pop_total_60_64  = rowtotal(a6064*)
egen pop_total_65_69  = rowtotal(a6569*)
egen pop_total_70_74  = rowtotal(a7074*)
egen pop_total_75_79  = rowtotal(a7579*)
egen pop_total_80_84  = rowtotal(a8084*)
egen pop_total_85_110 = rowtotal(a85110*)
keep year fips pop*
tempfile pop1970s
save `pop1970s'
    
insheet using "$DAT/`p1980'", comma names clear
rename group group2
gen     group = 1 if group2 == "White male"
replace group = 2 if group2 == "White female"
replace group = 3 if group2 == "Black male"
replace group = 4 if group2 == "Black female"
replace group = 5 if group2 == "Other races male"
replace group = 6 if group2 == "Other races female"
drop group2

reshape wide a*, i(year fips) j(group)
egen pop_total        = rowtotal(a*)
egen pop_black_female = rowtotal(a054-a851104)
egen pop_black_male   = rowtotal(a053-a851103)
egen pop_white_female = rowtotal(a052-a851102)
egen pop_white_male   = rowtotal(a051-a851101)
egen pop_other_female = rowtotal(a056-a851106)
egen pop_other_male   = rowtotal(a055-a851105)
egen pop_total_0_5    = rowtotal(a05*)
egen pop_total_5_9    = rowtotal(a59*)
egen pop_total_10_14  = rowtotal(a1014*)
egen pop_total_15_19  = rowtotal(a1519*)
egen pop_total_20_24  = rowtotal(a2024*)
egen pop_total_25_29  = rowtotal(a2529*)
egen pop_total_30_34  = rowtotal(a3034*)
egen pop_total_35_39  = rowtotal(a3539*)
egen pop_total_40_44  = rowtotal(a4044*)
egen pop_total_45_49  = rowtotal(a4549*)
egen pop_total_50_54  = rowtotal(a5054*)
egen pop_total_55_59  = rowtotal(a5559*)
egen pop_total_60_64  = rowtotal(a6064*)
egen pop_total_65_69  = rowtotal(a6569*)
egen pop_total_70_74  = rowtotal(a7074*)
egen pop_total_75_79  = rowtotal(a7579*)
egen pop_total_80_84  = rowtotal(a8084*)
egen pop_total_85_110 = rowtotal(a85110*)
keep year fips pop*

append using `pop1970s'


*-------------------------------------------------------------------------------
*--- (3) Save and close
*-------------------------------------------------------------------------------
lab dat "Population data 1970-1989 from Census Bureau"
save "$DAT/countyPopulation.dta", replace
