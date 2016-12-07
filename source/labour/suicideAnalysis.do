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

foreach ado in estout {
    cap which `ado'
    if _rc!=0 ssc install `ado'
}
#delimit ;
local estopt cells(b(star fmt(%-9.3f)) se(fmt(%-9.3f) par([ ]) )) stats
(N r2, fmt(%9.0g %5.3f) labels(Observations R-squared)) collabels(none) label;
#delimit cr
*-------------------------------------------------------------------------------
*--- (2) Create state cells
*-------------------------------------------------------------------------------
use "$DAT/labor/clean_1969_2000_all"
destring geofips, gen(fips)

drop if fips==0
gen stateOnly = regexm(geoname, "state total")
drop if stateOnly==1
drop stateOnly

replace fips = 51001 if geoname=="Accomack, VA "
replace fips = 51003 if geoname=="Albemarle + Charlottesville, VA "
replace fips = 51005 if geoname=="Alleghany + Covington, VA "
replace fips = 51007 if geoname=="Amelia, VA "
replace fips = 51009 if geoname=="Amherst, VA "
replace fips = 51011 if geoname=="Appomattox, VA "
replace fips = 51013 if geoname=="Arlington, VA "
replace fips = 51015 if geoname=="Augusta, Staunton + Waynesboro, VA "
replace fips = 51017 if geoname=="Bath, VA "
replace fips = 51019 if geoname=="Bedford + Bedford City, VA "
replace fips = 51021 if geoname=="Bland, VA "
replace fips = 51023 if geoname=="Botetourt, VA "
replace fips = 51025 if geoname=="Brunswick, VA "
replace fips = 51027 if geoname=="Buchanan, VA "
replace fips = 51029 if geoname=="Buckingham, VA "
replace fips = 51031 if geoname=="Campbell + Lynchburg, VA "
replace fips = 51033 if geoname=="Caroline, VA "
replace fips = 51035 if geoname=="Carroll + Galax, VA "
replace fips = 51036 if geoname=="Charles City, VA "
replace fips = 51037 if geoname=="Charlotte, VA"
replace fips = 51041 if geoname=="Chesterfield, VA "
replace fips = 51043 if geoname=="Clarke, VA "
replace fips = 51045 if geoname=="Craig, VA "
replace fips = 51047 if geoname=="Culpeper, VA "
replace fips = 51049 if geoname=="Cumberland, VA "
replace fips = 51051 if geoname=="Dickenson, VA "
replace fips = 51053 if geoname=="Dinwiddie, Colonial Heights + Petersburg, VA "
replace fips = 51057 if geoname=="Essex, VA "
replace fips = 51059 if geoname=="Fairfax, Fairfax City + Falls Church, VA "
replace fips = 51061 if geoname=="Fauquier, VA "
replace fips = 51063 if geoname=="Floyd, VA "
replace fips = 51065 if geoname=="Fluvanna, VA "
replace fips = 51067 if geoname=="Franklin, VA "
replace fips = 51069 if geoname=="Frederick + Winchester, VA "
replace fips = 51071 if geoname=="Giles, VA "
replace fips = 51073 if geoname=="Gloucester, VA "
replace fips = 51075 if geoname=="Goochland, VA "
replace fips = 51077 if geoname=="Grayson, VA "
replace fips = 51079 if geoname=="Greene, VA "
replace fips = 51081 if geoname=="Greensville + Emporia, VA "
replace fips = 51083 if geoname=="Halifax, VA "
replace fips = 51085 if geoname=="Hanover, VA "
replace fips = 51087 if geoname=="Henrico, VA "
replace fips = 51089 if geoname=="Henry + Martinsville, VA "
replace fips = 51091 if geoname=="Highland, VA "
replace fips = 51093 if geoname=="Isle of Wight, VA "
replace fips = 51095 if geoname=="James City + Williamsburg, VA "
replace fips = 51097 if geoname=="King and Queen, VA "
replace fips = 51099 if geoname=="King George, VA "
replace fips = 51101 if geoname=="King William, VA "
replace fips = 51103 if geoname=="Lancaster, VA "
replace fips = 51105 if geoname=="Lee, VA "
replace fips = 51107 if geoname=="Loudoun, VA "
replace fips = 51109 if geoname=="Louisa, VA "
replace fips = 51111 if geoname=="Lunenburg, VA "
replace fips = 51113 if geoname=="Madison, VA "
replace fips = 51115 if geoname=="Mathews, VA "
replace fips = 51117 if geoname=="Mecklenburg, VA "
replace fips = 51119 if geoname=="Middlesex, VA "
replace fips = 51121 if geoname=="Montgomery + Radford, VA "
*replace fips = 51183 if geoname=="Nansemond, VA "***
replace fips = 51125 if geoname=="Nelson, VA "
replace fips = 51127 if geoname=="New Kent, VA "
replace fips = 51131 if geoname=="Northampton, VA "
replace fips = 51133 if geoname=="Northumberland, VA "
replace fips = 51135 if geoname=="Nottoway, VA "
replace fips = 51137 if geoname=="Orange, VA "
replace fips = 51139 if geoname=="Page, VA "
replace fips = 51141 if geoname=="Patrick, VA "
replace fips = 51143 if geoname=="Pittsylvania + Danville, VA "
replace fips = 51145 if geoname=="Powhatan, VA "
replace fips = 51147 if geoname=="Prince Edward, VA "
replace fips = 51149 if geoname=="Prince George + Hopewell, VA "
replace fips = 51153 if geoname=="Prince William, Manassas + Manassas Park, VA "
replace fips = 51155 if geoname=="Pulaski, VA "
replace fips = 51157 if geoname=="Rappahannock, VA "
replace fips = 51159 if geoname=="Richmond, VA "
replace fips = 51161 if geoname=="Roanoke + Salem, VA "
replace fips = 51163 if geoname=="Rockbridge, Buena Vista + Lexington, VA "
replace fips = 51165 if geoname=="Rockingham + Harrisonburg, VA "
replace fips = 51167 if geoname=="Russell, VA "
replace fips = 51169 if geoname=="Scott, VA "
replace fips = 51171 if geoname=="Shenandoah, VA "
replace fips = 51173 if geoname=="Smyth, VA "
replace fips = 51175 if geoname=="Southampton + Franklin, VA "
replace fips = 51177 if geoname=="Spotsylvania + Fredericksburg, VA "
replace fips = 51179 if geoname=="Stafford, VA "
replace fips = 51181 if geoname=="Surry, VA "
replace fips = 51183 if geoname=="Sussex, VA "
replace fips = 51185 if geoname=="Tazewell, VA "
replace fips = 51187 if geoname=="Warren, VA "
replace fips = 51191 if geoname=="Washington + Bristol, VA "
replace fips = 51193 if geoname=="Westmoreland, VA "
replace fips = 51195 if geoname=="Wise + Norton, VA "
replace fips = 51197 if geoname=="Wythe, VA "
replace fips = 51199 if geoname=="York + Poquoson, VA "
replace fips = 51510 if geoname=="Alexandria (Independent City), VA "
*replace fips = 51300 if geoname=="Bristol city, VA "***
*replace fips = 51303 if geoname=="Buena Vista city, VA "***
*replace fips = 51306 if geoname=="Charlottesville city, VA "***
*replace fips = 51307 if geoname=="Chesapeake (Independent City), VA "
**replace fips = 51309 if geoname=="Clifton Forge city, VA "***
**replace fips = 51312 if geoname=="Colonial Heights city, VA "***
**replace fips = 51315 if geoname=="Covington city, VA "***
**replace fips = 51318 if geoname=="Danville city, VA "***
**replace fips = 51321 if geoname=="Fairfax city, VA "***
**replace fips = 51324 if geoname=="Falls Church city, VA "***
**replace fips = 51327 if geoname=="Franklin city, VA "***
**replace fips = 51330 if geoname=="Fredericksburg city, VA "***
**replace fips = 51333 if geoname=="Galax city, VA "***
*replace fips = 51336 if geoname=="Hampton (Independent City), VA "
**replace fips = 51339 if geoname=="Harrisonburg city, VA "***
**replace fips = 51342 if geoname=="Hopewell city, VA "***
**replace fips = 51345 if geoname=="Lynchburg city, VA "***
**replace fips = 51348 if geoname=="Martinsville city, VA "***
*replace fips = 51351 if geoname=="Newport News (Independent City), VA "
*replace fips = 51354 if geoname=="Norfolk (Independent City), VA "
*replace fips = 51357 if geoname=="Norton (Independent City), VA "
**replace fips = 51360 if geoname=="Petersburg city, VA "***
*replace fips = 51363 if geoname=="Portsmouth (Independent City), VA "
**replace fips = 51366 if geoname=="Radford city, VA "***
*replace fips = 51369 if geoname=="Richmond (Independent City), VA "
*replace fips = 51372 if geoname=="Roanoke (Independent City), VA "
**replace fips = 51375 if geoname=="South Boston city, VA "***
**replace fips = 51381 if geoname=="Staunton city, VA "***
*replace fips = 51384 if geoname=="Suffolk (Independent City), VA "
*replace fips = 51387 if geoname=="Virginia Beach (Independent City), VA "
**replace fips = 51390 if geoname=="Waynesboro city, VA "
**replace fips = 51393 if geoname=="Williamsburg city, VA "
**replace fips = 51396 if geoname=="Winchester city, VA "
**replace fips = 51401 if geoname=="Bedford city, VA "
**replace fips = 51402 if geoname=="Lexington city, VA "
**replace fips = 51403 if geoname=="Manassas city, VA "
**replace fips = 51404 if geoname=="Salem city, VA "
**replace fips = 51405 if geoname=="Emporia city, VA "
**replace fips = 51406 if geoname=="Manassas Park city, VA "
**replace fips = 51407 if geoname=="Poquoson city, VA "


tempfile labour
save `labour'

use "$DAT/suicides/suicideMicrodata_1959-1988.dta", clear
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

merge 1:1 fips year using `labour'
drop if year==1969|year>=1990
tab _merge
**Need to fix VA fips
keep if _merge==3

*-------------------------------------------------------------------------------
*--- (3) Generate employment variables
*-------------------------------------------------------------------------------
#delimit ;
gen pop_total_20_64=pop_total_20_24+pop_total_25_29+pop_total_30_34+
    pop_total_35_39+pop_total_40_44+pop_total_45_49+pop_total_50_54+
    pop_total_55_59+pop_total_60_64;
gen pop_total_15_64=pop_total_20_24+pop_total_25_29+pop_total_30_34+
    pop_total_35_39+pop_total_40_44+pop_total_45_49+pop_total_50_54+
    pop_total_55_59+pop_total_60_64+pop_total_15_19;
gen pop_total_15_plus=pop_total_20_24+pop_total_25_29+pop_total_30_34+
    pop_total_35_39+pop_total_40_44+pop_total_45_49+pop_total_50_54+
    pop_total_55_59+pop_total_60_64+pop_total_15_19+pop_total_65_69+
    pop_total_70_74+pop_total_75_79+pop_total_80_84+pop_total_85_110;
gen empShare  = emptotal_empl/pop_total_20_64;
gen empShare2 = emptotal_empl/pop_total_15_64;
gen empShare3 = emptotal_empl/pop_total_15_plus;
#delimit cr

bys fips (year): gen empShare_t1 = empShare3[_n-1]
bys fips (year): gen empShare_t2 = empShare3[_n-2]
bys fips (year): gen empDelta    = empShare3[_n]-empShare3[_n-1]

preserve
keep if emptotal_empl<7000000
replace emptotal_empl=emptotal_empl/1000
replace pop_total_15_plus=pop_total_15_plus/1000
#delimit ;
scatter emptotal_empl pop_total_15_plus, scheme(s1mono)
ytitle("Total Employment in 1000s")
xtitle("Total Population in 1000s (15+)") mcolor(red);
graph export "$OUT/EmploymentPop.eps", as(eps) replace;
#delimit cr
restore
*-------------------------------------------------------------------------------
*--- (4) Descriptive statistics
*-------------------------------------------------------------------------------
lab var pop_total_15_plus "Total Population 15 and older"
lab var year              "Year"
lab var suicideRate       "Suicide Rate per 100,000"
lab var empShare3         "Share of Population Employed"
lab var empDelta          "Change in Employment Share"
lab var emptotal_emp      "Total Employment in County"

#delimit ;
local svars year pop_total_15_plus suicideRate emptotal_e empShare3 empDelta;
estpost tabstat `svars', statistics(count mean sd min max) columns(statistics);
esttab using "$OUT/sumStats.tex", replace label noobs
title("Basic Descriptive Statistics")
cells("count(fmt(0)) mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))");
#delimit cr
    
*-------------------------------------------------------------------------------
*--- (5) Run some basic regressions
*-------------------------------------------------------------------------------
local wt [aw=pop_total_15_plus]

eststo: areg suicideRate empShare3 i.year           , abs(fips)
eststo: areg suicideRate empShare3 empShare_* i.year, abs(fips)
eststo: areg suicideRate empDelta i.year            , abs(fips)

eststo: areg suicideRate empShare3 i.year            `wt', abs(fips)
eststo: areg suicideRate empShare3 empShare_* i.year `wt', abs(fips)
eststo: areg suicideRate empDelta i.year             `wt', abs(fips)
lab var suicideRate "Suicides"
lab var empShare_t1 "Share Employed (t-1)"
lab var empShare_t2 "Share Employed (t-2)"

#delimit ;
esttab est1 est2 est3 est4 est5 est6 using "$OUT/RegCorrelations.tex",
replace `estopt' keep(empShare3 empDelta empShare_t1 empShare_t2)
title("Basic Correlations: Suicides and Labour Market") style(tex)
mlabels(, depvar) booktabs starlevels(* 0.10 ** 0.05 *** 0.01)
mgroups("County Averages" "Weighted by County Population", pattern(1 0 0 1 0 0)
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
postfoot("\bottomrule \multicolumn{7}{p{15.2cm}}{\begin{footnotesize} "
         "All regressions include county FIPS code and year fixed "
         "effects and are estimated by OLS. The dependent variable    "
         "Suicides refers to the suicide rate per 100,000 people      "
         "residing in the county.  Weights are based on county        "
         "population of individuals 15 years of age and older."
         "\end{footnotesize}}\end{tabular}\end{table}");
#delimit cr
estimates clear

collapse suicideRate empShare3, by(fips)
*-------------------------------------------------------------------------------
*--- (6) Map variables
*-------------------------------------------------------------------------------
merge 1:1 fips using "$DAT/geography/c_data", gen(_mapMerge)
format %5.2f suicideRate
format %5.2f empShare3

local d1 drop if _ID==15|_ID==23|_ID==37|_ID==44|_ID==50|_ID==51|_ID==52

#delimit ;
drop if STATEFP=="02"|STATEFP=="15"|STATEFP=="60"|STATEFP=="66"|STATEFP=="69"|
        STATEFP=="72"|STATEFP=="78";

spmap suicideRate using "$DAT/geography/c_coords_mercator", id(_ID)
ocolor(none ..) fcolor(Heat) legstyle(2)
legend(symy(*1.2) symx(*1.2) size(*1.5) rowgap(1) title("Suicide Rate"))
line(data("$DAT/geography/s_coords_mercator.dta") size(*1.0) color(black)
     select(`d1'));
graph export "$OUT/suicideRateCounties.eps", replace;

replace empShare3=1 if empShare3>=1&empShare3!=.;
spmap empShare3 using "$DAT/geography/c_coords_mercator", id(_ID)
ocolor(none ..) fcolor(Heat) legstyle(2)
legend(symy(*1.2) symx(*1.2) size(*1.5) rowgap(1) title("Employment Share"))
line(data("$DAT/geography/s_coords_mercator.dta") size(*1.0) color(black)
     select(`d1'));
graph export "$OUT/employmentShareCounties.eps", replace;
