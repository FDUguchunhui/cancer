libname B "Z:\8 GQ Zhang group";
%include "Z:\8 GQ Zhang group\STEP1 data analysis\Macro Freq no p value.sas";

***Figure 1: Consort diagram;
proc contents data=B.rawdata0;
run;
data raw1;
set B.rawdata0;
COVID_year=year(COVID_diag_date);
age=(covid_year-birth_yr);
run; 
data raw1_include; set raw1; where age>=18; run;

data raw1_exclude;
set raw1;
where age=. or age<18; 
run;

data raw2_include;
set raw1_include;
where COVID_diag_date>=cancer_date;
run;
proc freq data=raw2_include;
tables cancer;
run;
***Table 1 and 2;
data rawdata_cancer;
set B.rawdata;
if gender="Unknown" then gender="z: Unknown"; *rename to make this category appear in the last row;
if age_cancer_gp="miss" then age_cancer_gp="z: Unknown";
if age_gp="" then age_gp="z: Unknown";
if obese_overweight="" then obese_overweight="z: Unknown";
if Surgery_4w=1 then surgery4wk="Yes";
else if Surgery_4w=0 then surgery4wk="No";
else if Surgery_4w=. then surgery4wk="z: Unknown";
where cancer=1 and (chemo_4w=1 or Radiation_4w=1);
run;

data rawdata_nocancer;
set B.rawdata;
if gender="Unknown" then gender="z: Unknown"; *rename to make this category appear in the last row;
if age_cancer_gp="miss" then age_cancer_gp="z: Unknown";
if age_gp="" then age_gp="z: Unknown";
if obese_overweight="" then obese_overweight="z: Unknown";
if Surgery_4w=1 then surgery4wk="Yes";
else if Surgery_4w=0 then surgery4wk="No";
else if Surgery_4w=. then surgery4wk="z: Unknown";
where cancer=0;
run;

data rawdata; set rawdata_cancer rawdata_nocancer; run;
   
proc datasets; delete S0-S20; run;
%twoway_digital_Outcome(rawdata,cancer, 0,1,death,1 );
%twoway_digital_Outcome(rawdata,cancer, 0,1,Inpatient,2 );
%twoway_digital_Outcome(rawdata,cancer, 0,1,ICU,3);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Ventilation,4);
%twoway_digital_Outcome(rawdata,cancer, 0,1,severity,5);
%twoway_digital_Outcome(rawdata,cancer, 0,1,severity_level,6);

*independent variables;
%twoway_nominal(rawdata, cancer, 0,1, age_gp,7);
%twoway_nominal(rawdata,cancer, 0,1,gender,8);
%twoway_nominal(rawdata,cancer, 0,1,race_gp,9);
%twoway_nominal(rawdata,cancer, 0,1,Region,10);
%twoway_nominal(rawdata,cancer, 0,1,N_comorbity_gp,11);
%twoway_nominal(rawdata,cancer, 0,1,N_Posi_Comorb_gp,12);
%twoway_nominal(rawdata,cancer, 0,1,surgery4wk,13);
%twoway_nominal(rawdata,cancer, 0,1,cancer_type,14);
%twoway_digital(rawdata,cancer, 0,1,chemo_4w,15);
%twoway_digital(rawdata,cancer, 0,1,Radiation_4w,16);
%twoway_nominal(rawdata,cancer, 0,1,age_cancer_gp,17);
%twoway_digital(rawdata,cancer, 0,1,survive_5yr_more,18);
  
 
data Table_outcome;
set S1-S5;
if level=0 or level="N" then delete;
id=_n_;
run;
data Table_outcome;
set Table_outcome S6;
run;
data Table_indep;
set S7-S18;
id=_n_;
run;

proc sort data=Table_outcome; by id; run;
proc sort data=Table_indep; by id; run;

 

options orientation=landscape;
ods rtf file="Z:\8 GQ Zhang group\STEP1 data analysis\OUTPUT\active cancer tables.rtf" startpage=never;
ods text="0. Two groups, 0 for non-cancer, 1 for cancer";
proc freq data=rawdata;
tables cancer;
run; 
ods text="Table 2. Outcomes for cancer and non-cancer groups";
proc print data=Table_outcome noobs;
var variable level cancer0 cancer1 ;
run;  
ods rtf close;
  
