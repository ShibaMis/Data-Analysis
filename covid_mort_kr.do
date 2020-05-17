/*########################################################################################
#Title: Analysis of COVID-19 data for mortality in Korea
#Author: Ashis K Das, Saji S Gopalan
#Date created: Apr 14, 2020
########################################################################################*/

clear

cap log close

import delimited "C:\Users\wb353328\OneDrive - WBG\Claims\covid\data\PatientInfo.csv"

g id=_n
encode sex, g(sex1)
drop if sex1==.
encode age, g(age1)
drop age
g age=.
replace age=0 if age1==1
replace age=1 if age1==3
replace age=2 if age1==4
replace age=3 if age1==5
replace age=4 if age1==6
replace age=5 if age1==7
replace age=6 if age1==8 | age1==9
replace age=7 if age1==10
replace age=8 if age1==11
replace age=9 if age1==12 | age1==2

la def age 0 "Below 10" 1 "10-19" 2 "20-29" 3 "30-39" 4 "40-49" 5 "50-59" 6 "60-69" 7 "70-79" 8 "80-89" 9 "90 and above"
la var age age
la val age age

drop if age==.

encode province, g(province1)

encode infection_case, g(infection_mode)

g mode=.
replace mode=0 if infection_mode==1 | infection_mode==10
replace mode=1 if infection_mode==3 | infection_mode==5
replace mode=2 if infection_mode==4 | infection_mode==6 | infection_mode==13 | infection_mode==15 | infection_mode==17
replace mode=3 if infection_mode==7
replace mode=4 if infection_mode==2 | infection_mode==8 | infection_mode==9 | infection_mode==11 | infection_mode==16
replace mode=5 if infection_mode==21 | infection_mode==22
replace mode=6 if infection_mode==23 | infection_mode==14
replace mode=7 if infection_mode==19
replace mode=8 if infection_mode==12| infection_mode==18| infection_mode==20 | infection_mode==.

la def mode 0 "Nursing home" 1 "Hospital" 2 "Religious gathering" 3 "Call center" ///
	4 "Community center, shelter and apartments" 5 "Gym facility" 6 "Overseas inflow" ///
	7 "Contact with patients" 8 "Others" 
la var mode "infection mode"
la val mode mode	
  
g newdate = subinstr(confirmed_date , "/", "-", .)
g date_int = date(newdate, "MDY")
egen date=cut(date_int), at(21934,21940,21947,21954,21961,21968,21975,21982,21989,21996,22003,22013) label
la drop date
la def date 0 "20-26 Jan 2020" 1 "27 Jan-02 Feb 2020" 2 "03-09 Feb 2020" 3 "10-16 Feb 2020" ///
	4 "17-23 Feb 2020" 5 "24 Feb-01 Mar 2020" 6 "02-08 Mar 2020" 7 "09-15 Mar 2020" ///
	8 "16-22 Mar 2020" 9 "23-29 Mar 2020" 10 "30 Mar-07 Apr 2020"
la var date "Date of diagnosis"
la val date date

encode state, g(outcome)
g death=outcome==1

keep age sex1 province1 mode date death

ren (sex1 province1) (sex province)

la var sex "Sex"
la var province "Province"
la var death "Death"
ren mode exposure

save "C:\Users\wb353328\OneDrive - WBG\Claims\covid\data\covid_kr", replace
export delimited using "C:\Users\wb353328\OneDrive - WBG\Claims\covid\data\covid_kr.csv", nolabel replace
/*
replace death = 0 in 1/1511
replace death = 1 in 1511/3022
*******************************************************************************************************************************************
clear
import delimited "C:\Users\wb353328\OneDrive - WBG\Claims\covid\data\latestdata.csv"
*keep relevant vars
keep age sex date_onset_symptoms date_admission_hospital date_confirmation outcome country_new
g id=_n

encode sex, g(sex1)
encode country_new, g(country1)
encode age, g(age1)
encode outcome, g(outcome1)
encode date_onset_symptoms, g(date_onset)
encode date_admission_hospital, g(date_hosp)
encode date_confirmation, g(date_conf)

drop if age1==.
keep if sex1==2 | sex1==3
drop if outcome1==.
drop if date_hosp==.
*/
