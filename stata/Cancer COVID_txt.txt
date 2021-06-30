
*Data Import
import delimited "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021.csv", varnames(1) clear 
save "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021.dta", replace

import delimited "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021_cancer_dxcodes.csv", varnames(1) clear 
save "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021_cancer_dxcodes.dta", replace

use "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021_cancer_dxcodes.dta", clear

use "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021.dta", clear
gen covid_date=date(covid_pcr_date, "MDY")
keep patient_id covid_date
gen ptid=patient_id
merge 1:m ptid using "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021_cancer_dxcodes.dta"
keep if _merge==3

bys ptid: gen num=1 if _n==1
gen cancerdx_date=date(cancer_date, "MDY")
gen cancer_year=year(cancerdx_date)
bys ptid: egen most_recent_cancer_yr=max(cancer_year)
tab most_recent_cancer_yr if num==1
bys ptid: egen most_recent_cancer_date=max(cancerdx_date)

bys ptid: egen first_cancer_yr=min(cancer_year)
tab first_cancer_yr if num==1
bys ptid: egen first_cancer_date=min(cancerdx_date)

gen dx2=substr(cancer_dxcode,1,2)
gen dx3=substr(cancer_dxcode,1,3)
gen hematological=0
replace hematological=1  if inlist(dx2,"C8", "C9","20")
label define hematologicaln 0 "Solid Tumors" 1 "Hematological malignancies"
label values hematological hematologicaln
gen solid=0
replace solid=1 if hematological==0
gen metastatic=0
replace metastatic=1 if inlist(dx3, "C7B", "C77", "C78","C79","196","197","198")
bys ptid: egen f_solid=max(solid)
bys ptid: egen f_hematological=max(hematological)
bys ptid: egen f_metastatic=max(metastatic)
sort ptid cancerdx_date
bys ptid: keep if _n==_N /*MOST RECENT*/
keep patient_id most_recent_cancer_yr most_recent_cancer_date first_cancer_yr first_cancer_date cancer_dxcode dx2 dx3 hematological solid metastatic f_hematological f_solid f_metastatic  
merge 1:1 patient_id using "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021.dta"

gen covid_date=date(covid_pcr_date, "MDY")
gen covid_year=year(covid_date)
gen covid_month_temp=month(covid_date)
gen covid_month=ym(covid_year, covid_month_temp)

gen recent_cancer=0
replace recent_cancer=1 if most_recent_cancer_date>=(covid_date-365) & _merge==3

gen death_date=date(date_of_death, "MDY")
gen death_year=year(death_date)
gen death_month_temp=month(death_date)
gen death_month=ym(death_year, death_month_temp)

format covid_month death_month %tm
gen age=2020-birth_yr

gen death_date2=dofm(death_month+1)-1
gen cohort_entry_date=date(entry_date, "MDY")
gen cohort_exit_date=date(exit_date, "MDY")
gen cohort_entry_yr=year(cohort_entry_date)
gen cohort_exit_yr=year(cohort_exit_date)

gen lookback=covid_date- cohort_entry_date
format death_date death_date2 cohort_entry_date cohort_exit_date %td
drop covid_month_temp death_month_temp _merge

*Population Check
count /*503,271*/
count if covid_month>death_month
count if covid_month<722
count if (covid_month>death_month| covid_month<722) 
drop if (covid_month>death_month| covid_month<722)
count  /*  502,851*/

gen death30=0
replace death30=1 if death_month<=(covid_month+1)
gen death90=0
replace death90=1 if death_month<=(covid_month+3)

gen survival_month=death_month- covid_month if death_month!=.
gen enddate= mdy(1,31,2021)
replace enddate=death_date if deceased_indicator==1
replace enddate=death_date2 if deceased_indicator==1 & death_date<=covid_date
format enddate %td

gen fu_date=cohort_exit_date
replace fu_date=death_date if deceased_indicator

recode age (0/17=1 "<18") (18/24=2 "18-24") (25/34=3 "25-34") (35/44=4 "35-44") (45/54=5 "45-54") (55/64=6 "55-64") (65/74=7 "65-74") (75/84=8 "75-84") (85/max=9 "85+") (.=10 "Unknown"), gen(agegrp)
recode age (0/17=1 "<18") (18/24=2 "18-24") (25/34=3 "25-34") (35/44=4 "35-44") (45/54=5 "45-54") (55/64=6 "55-64") (65/74=7 "65-74") (75/max=8 "75+") (.=10 "Unknown"), gen(agegrp2)

gen rh=1 if race=="Caucasian" & (ethnicity=="Not Hispanic" | ethnicity=="Unknown") /*Judgement call: Too high percentage of unknown ethnicity but with non-missing race*/
replace rh=2 if race=="African American"  & (ethnicity=="Not Hispanic" | ethnicity=="Unknown")
replace rh=3 if ethnicity=="Hispanic"
replace rh=4 if rh==.
recode rh (1=1 "White") (2=2 "Black") (3=3 "Hispanic") (4=4 "Other/unknown"), gen(racehisp)
drop rh

gen male=1 if gender=="Male"
replace male=0 if gender=="Female"

gen region_temp=5
replace region_temp=1 if region=="Northeast"
replace region_temp=2 if region=="Midwest"
replace region_temp=3 if region=="South"
replace region_temp=4 if region=="West"
recode region_temp (1=1 "Northeast") (2=2 "Midwest") (3=3 "South") (4=4 "West") (5=5 "Other/Unknown"), ge(region2)
drop region_temp


*tabstat hiv renal hemiplegia diabetes_with_cc diabetes_without_cc severe_liver mild_liver peptic_ulcer rheumatic  cerebrovascular dementia heart_failure myocardial_infarction obesity cardiovascular smoking_infarction
egen diab=rowmax(diabetes_with_cc diabetes_without_cc)
egen liver=rowmax( severe_liver mild_liver)

save "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021_cancer_analytic.dta", replace


***1. Checking data **************************************
use "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021_cancer_analytic.dta", clear
tab survival_month

*Check mortality by month
tab covid_month
tab covid_month if deceased_indicator==1
tab covid_month if death30==1
tab covid_month if death90==1

*Last year of having any cancer diagnosis among COVID-19 patients
tab most_recent_cancer_yr
tab first_cancer_yr
tab cohort_entry_yr
tab cohort_entry_yr if cancer==1



***2. Study Population*********************************
tab covid_month
keep if covid_month>=725 & covid_month<=731
count
count if birth_yr==.
count if age<18
count if gender=="Unknown"
count if age==. | age<18 | gender=="Unknown"
drop if age==. | age<18 | gender=="Unknown"
count
count if lookback<365
drop if lookback<365
count
count if first_cancer_date>covid_date & cancer==1
save "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021_cancer_analytic2.dta", replace

****Analysis
use "X:\ShethLabShared\Optum_COVID_EMR\Projects\Cancer\Cancer_COVID_project_06182021_cancer_analytic2.dta", clear
tab cancer
tab recent_cancer if cancer==1

*Table 1
gen nocancer=0
replace nocancer=1 if cancer==0

table1_mc, by(nocancer) vars(age conts \ agegrp cat\ male bin\ racehisp cat\ region2 cat\ myocardial_infarction bin \ heart_failure bin \ chronic_pulmonary bin\ cerebrovascular bin \ peripheral_vascular bin \ diab bin\ liver bin\ renal bin \ rheumatic bin \ peptic_ulcer bin \ hemiplegia bin\ hiv bin) percsign("") total(before)

psmatch2 cancer i.agegrp i.male i.racehisp i.region2 i.myocardial_infarction i.heart_failure i.chronic_pulmonary i.cerebrovascular i.peripheral_vascular i.diab i.liver i.renal, logit caliper(.1) neighbor(1) noreplacement
tab _weight cancer, m

table1_mc if _weight==1, by(nocancer) vars(age conts \ agegrp cat\ male bin\ racehisp cat\ region2 cat\ myocardial_infarction bin \ heart_failure bin \ chronic_pulmonary bin\ cerebrovascular bin \ peripheral_vascular bin \ diab bin\ liver bin\ renal bin \ rheumatic bin \ peptic_ulcer bin \ hemiplegia bin\ hiv bin) percsign("") total(before)

table1_mc if cancer==1, by(recent_cancer) vars(age conts \ agegrp cat\ male bin\ racehisp cat\ region2 cat\ myocardial_infarction bin \ heart_failure bin \ chronic_pulmonary bin\ cerebrovascular bin \ peripheral_vascular bin \ diab bin\ liver bin\ renal bin \ rheumatic bin \ peptic_ulcer bin \ hemiplegia bin\ hiv bin) percsign("") 



*Table 2
table1_mc, by(nocancer) vars(hospitalization bin\ icu bin\ ventilator bin\ deceased_indicator bin\death30 bin\death90 bin) percsign("") 

table1_mc if _weight==1, by(nocancer) vars(hospitalization bin\ icu bin\ ventilator bin\ deceased_indicator bin\death30 bin\death90 bin) percsign("") 

foreach x in hospitalization icu ventilator deceased_indicator death30 death90  {
glm `x' i.cancer, fam(poisson) link(log) vce(robust) nolog eform
}

foreach x in hospitalization icu ventilator deceased_indicator death30 death90  {
glm `x' i.cancer if _weight==1, fam(poisson) link(log) vce(robust) nolog eform
}

table1_mc if cancer==1, by(recent_cancer) vars(hospitalization bin\ icu bin\ ventilator bin\ deceased_indicator bin\death30 bin\death90 bin) percsign("") 



*survival analysis
gen fu=enddate-covid_date
stset fu, failure(deceased_indicator)
sts graph, by(cancer) tmax(120)

gen cancer2=0
replace cancer2=1 if recent_cancer==0 & cancer==1
replace cancer2=2 if recent_cancer==1
label define cancer2l 0 "No cancer history" 1 "Cancer history, no recent" 2 "Cancer history, recent"
label value cancer2 cancer2l 

sts graph if _weight==1, by(cancer) tmax(120) ylabel(0.80(0.05)1) ci
sts graph if _weight==1, by(cancer2) tmax(120) ylabel(0.80(0.05)1) ci legend(order(1 "No cancer, 95% CI" 2  "No cancer" 3 "Cancer, no recent 95% CI" 4 "Cancer, no recent" 5 "Cancer, recent 95% CI" 6 "Cancer, recent") row(3) pos(3) ring(0) size(small))

sts graph if cancer==1, by(f_hematological) tmax(120) ylabel(0.80(0.05)1) ci
sts graph if cancer==1, by(f_metastatic) tmax(120) ylabel(0.80(0.05)1) ci

