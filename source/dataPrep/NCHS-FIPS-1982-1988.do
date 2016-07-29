global GEO "~/investigacion/2016/suicide/data/geography/"
use "$GEO/nchs2fips_county1990.dta", clear
set obs 3133
replace stateoc=11 in 3133
replace countyoc=1 in 3133
replace countyname = "Appling" in 3133
replace statename = "Georgia" in 3133
replace fipsst = 13 in 3133
replace fipsco = "13001" in 3133
set obs 3134
replace stateoc=9 in 3134
replace countyoc=1 in 3134
replace countyname = "District of Columbia" in 3134
replace statename = "District of Columbia" in 3134
replace fipsst = 11 in 3134
replace fipsco = "11001" in 3134
replace countyoc=66 if fipsco=="46135"
replace countyoc=67 if fipsco=="46137"
replace stateoc=51 if fipsco=="30113"
replace countyoc=24 if fipsco=="30113"

save "$GEO/nchs2fips_county1982-1988.dta", replace
