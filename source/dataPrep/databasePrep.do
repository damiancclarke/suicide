/* databasePrep.do v0.00         damiancclarke             yyyy-mm-dd:2016-12-16
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

Join data on mortality, population, and labour force.


*/

vers 11.2
clear all
set more off
cap log close

*-------------------------------------------------------------------------------
*--- (1) globals and locals
*-------------------------------------------------------------------------------
global POP "~/investigacion/2016/suicide/data/population"
global DAT "~/investigacion/2016/suicide/data/suicides"
global LAB "~/investigacion/2016/suicide/data/labor"
global GEO "~/investigacion/2016/suicide/data/geography"
global LOG "~/investigacion/2016/suicide/log"

log using "$LOG/databasePrep.txt", text replace

*-------------------------------------------------------------------------------
*--- (2) Use population as base: merge to suicides
*-------------------------------------------------------------------------------
use "$POP/county-population-1969-2015"
replace countyfips="   " if statefips=="36"&countyfips=="910"&year<2003
replace countyfips="   " if statefips=="36"&countyfips=="005"&year<2003
replace countyfips="   " if statefips=="36"&countyfips=="047"&year<2003
replace countyfips="   " if statefips=="36"&countyfips=="061"&year<2003
replace countyfips="   " if statefips=="36"&countyfips=="085"&year<2003

collapse (sum) pop*, by(year statefips countyfips state)
drop if year==2015
replace countyfips="001" if countyfips=="911"&statefips=="08"
replace countyfips="013" if countyfips=="912"&statefips=="08"
replace countyfips="059" if countyfips=="913"&statefips=="08"
replace countyfips="123" if countyfips=="914"&statefips=="08"

tempfile popdata
save `popdata'

use "$DAT/suicideMicrodata_1959-2014.dta", clear
gen countyfips = substr(fipsco,-3,.)
gen statefips  = string(fipsst, "%02.0f")
replace statefips="04" if fipsco=="04012"
replace countyfips="086" if countyfips=="025"&statefips=="12"
*Hawaii no pop data by county prior to 2000
replace countyfips="900" if statefips=="15"&datayear<2000
*Yuma changed
*replace countyfips="910" if statefips=="04"&datayear<1994
*Cibola changed
*replace countyfips="910" if statefips=="35"&datayear<1982


drop if statefips=="."
keep if datayear>1968
rename datayear year
drop _merge

merge m:1 statefips countyfips year using `popdata'

*-------------------------------------------------------------------------------
*--- (3) Create state*county*year-level data
*-------------------------------------------------------------------------------
drop if _merge==1
gen suicide=1 if _merge==3
replace suicide=0 if _merge==2

gen male  =suicide==1&sex==1
gen female=suicide==1&sex==2
drop popsize

collapse pop* (sum) suicide male female, by(year statefips countyfips)
tempfile suicides
save `suicides'

save "$DAT/suicides-county-1969-2014"

*-------------------------------------------------------------------------------
*--- (4) Merge to labour market data
*-------------------------------------------------------------------------------
use "$LAB/clean_1969_2000_all"
destring geofips, gen(fips)
drop if fips==0
gen stateOnly = regexm(geoname, "state total")
drop if stateOnly==1
drop stateOnly

gen countyfips = substr(geofips,-3,.)
gen statefips  = substr(geofips, 1,2)

replace countyfips="   " if statefips=="36"&countyfips=="910"&year<2003
replace countyfips="   " if statefips=="36"&countyfips=="005"&year<2003
replace countyfips="   " if statefips=="36"&countyfips=="047"&year<2003
replace countyfips="   " if statefips=="36"&countyfips=="061"&year<2003
replace countyfips="   " if statefips=="36"&countyfips=="085"&year<2003
replace geoname="NYC" if countyfips=="   "

replace countyfips = "001" if geoname=="Accomack, VA "
replace countyfips = "003" if geoname=="Albemarle + Charlottesville, VA "
replace countyfips = "005" if geoname=="Alleghany + Covington, VA "
replace countyfips = "007" if geoname=="Amelia, VA "
replace countyfips = "009" if geoname=="Amherst, VA "
replace countyfips = "011" if geoname=="Appomattox, VA "
replace countyfips = "013" if geoname=="Arlington, VA "
replace countyfips = "015" if geoname=="Augusta, Staunton + Waynesboro, VA "
replace countyfips = "017" if geoname=="Bath, VA "
replace countyfips = "019" if geoname=="Bedford + Bedford City, VA "
replace countyfips = "021" if geoname=="Bland, VA "
replace countyfips = "023" if geoname=="Botetourt, VA "
replace countyfips = "025" if geoname=="Brunswick, VA "
replace countyfips = "027" if geoname=="Buchanan, VA "
replace countyfips = "029" if geoname=="Buckingham, VA "
replace countyfips = "031" if geoname=="Campbell + Lynchburg, VA "
replace countyfips = "033" if geoname=="Caroline, VA "
replace countyfips = "035" if geoname=="Carroll + Galax, VA "
replace countyfips = "036" if geoname=="Charles City, VA "
replace countyfips = "037" if geoname=="Charlotte, VA"
replace countyfips = "041" if geoname=="Chesterfield, VA "
replace countyfips = "043" if geoname=="Clarke, VA "
replace countyfips = "045" if geoname=="Craig, VA "
replace countyfips = "047" if geoname=="Culpeper, VA "
replace countyfips = "049" if geoname=="Cumberland, VA "
replace countyfips = "051" if geoname=="Dickenson, VA "
replace countyfips = "053" if geoname=="Dinwiddie, Colonial Heights + Petersburg, VA "
replace countyfips = "057" if geoname=="Essex, VA "
replace countyfips = "059" if geoname=="Fairfax, Fairfax City + Falls Church, VA "
replace countyfips = "061" if geoname=="Fauquier, VA "
replace countyfips = "063" if geoname=="Floyd, VA "
replace countyfips = "065" if geoname=="Fluvanna, VA "
replace countyfips = "067" if geoname=="Franklin, VA "
replace countyfips = "069" if geoname=="Frederick + Winchester, VA "
replace countyfips = "071" if geoname=="Giles, VA "
replace countyfips = "073" if geoname=="Gloucester, VA "
replace countyfips = "075" if geoname=="Goochland, VA "
replace countyfips = "077" if geoname=="Grayson, VA "
replace countyfips = "079" if geoname=="Greene, VA "
replace countyfips = "081" if geoname=="Greensville + Emporia, VA "
replace countyfips = "083" if geoname=="Halifax, VA "
replace countyfips = "085" if geoname=="Hanover, VA "
replace countyfips = "087" if geoname=="Henrico, VA "
replace countyfips = "089" if geoname=="Henry + Martinsville, VA "
replace countyfips = "091" if geoname=="Highland, VA "
replace countyfips = "093" if geoname=="Isle of Wight, VA "
replace countyfips = "095" if geoname=="James City + Williamsburg, VA "
replace countyfips = "097" if geoname=="King and Queen, VA "
replace countyfips = "099" if geoname=="King George, VA "
replace countyfips = "101" if geoname=="King William, VA "
replace countyfips = "103" if geoname=="Lancaster, VA "
replace countyfips = "105" if geoname=="Lee, VA "
replace countyfips = "107" if geoname=="Loudoun, VA "
replace countyfips = "109" if geoname=="Louisa, VA "
replace countyfips = "111" if geoname=="Lunenburg, VA "
replace countyfips = "113" if geoname=="Madison, VA "
replace countyfips = "115" if geoname=="Mathews, VA "
replace countyfips = "117" if geoname=="Mecklenburg, VA "
replace countyfips = "119" if geoname=="Middlesex, VA "
replace countyfips = "121" if geoname=="Montgomery + Radford, VA "
*replace fips = 51183 if geoname=="Nansemond, VA "***
replace countyfips = "125" if geoname=="Nelson, VA "
replace countyfips = "127" if geoname=="New Kent, VA "
replace countyfips = "131" if geoname=="Northampton, VA "
replace countyfips = "133" if geoname=="Northumberland, VA "
replace countyfips = "135" if geoname=="Nottoway, VA "
replace countyfips = "137" if geoname=="Orange, VA "
replace countyfips = "139" if geoname=="Page, VA "
replace countyfips = "141" if geoname=="Patrick, VA "
replace countyfips = "143" if geoname=="Pittsylvania + Danville, VA "
replace countyfips = "145" if geoname=="Powhatan, VA "
replace countyfips = "147" if geoname=="Prince Edward, VA "
replace countyfips = "149" if geoname=="Prince George + Hopewell, VA "
replace countyfips = "153" if geoname=="Prince William, Manassas + Manassas Park, VA "
replace countyfips = "155" if geoname=="Pulaski, VA "
replace countyfips = "157" if geoname=="Rappahannock, VA "
replace countyfips = "159" if geoname=="Richmond, VA "
replace countyfips = "161" if geoname=="Roanoke + Salem, VA "
replace countyfips = "163" if geoname=="Rockbridge, Buena Vista + Lexington, VA "
replace countyfips = "165" if geoname=="Rockingham + Harrisonburg, VA "
replace countyfips = "167" if geoname=="Russell, VA "
replace countyfips = "169" if geoname=="Scott, VA "
replace countyfips = "171" if geoname=="Shenandoah, VA "
replace countyfips = "173" if geoname=="Smyth, VA "
replace countyfips = "175" if geoname=="Southampton + Franklin, VA "
replace countyfips = "177" if geoname=="Spotsylvania + Fredericksburg, VA "
replace countyfips = "179" if geoname=="Stafford, VA "
replace countyfips = "181" if geoname=="Surry, VA "
replace countyfips = "183" if geoname=="Sussex, VA "
replace countyfips = "185" if geoname=="Tazewell, VA "
replace countyfips = "187" if geoname=="Warren, VA "
replace countyfips = "191" if geoname=="Washington + Bristol, VA "
replace countyfips = "193" if geoname=="Westmoreland, VA "
replace countyfips = "195" if geoname=="Wise + Norton, VA "
replace countyfips = "197" if geoname=="Wythe, VA "
replace countyfips = "199" if geoname=="York + Poquoson, VA "
replace countyfips = "510" if geoname=="Alexandria (Independent City), VA "

collapse (sum) emp*, by(year statefips countyfips geoname)

merge 1:1 year countyfips statefips using `suicides'
