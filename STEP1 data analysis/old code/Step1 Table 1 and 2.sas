libname B "Z:\8 GQ Zhang group";
%include "Z:\8 GQ Zhang group\STEP1 data analysis\Macro Freq no p value.sas";

proc freq data=B.rawdata;
tables cancer smoke_status;
run;

 proc means data=B.rawdata n median Q1 Q3 print;
 class cancer;
 var age;
 run;

proc means data=B.rawdata n mean std maxdec=1 print;
class cancer;
var N_comorbity;
run;

proc means data=B.rawdata n mean std maxdec=1 print;
class cancer;
var N_Posi_Comorb;
run;

 proc freq data=B.rawdata;
 tables cancer*gender/nopercent nocol; 
 run;

proc freq data=B.rawdata;
tables cancer_type survive_5yr_more;
where cancer=1; 
run;



data rawdata;
set B.rawdata;
if gender="Unknown" then gender="z: Unknown";
if age_cancer_gp="miss" then age_cancer_gp="z: Unknown";
if age_gp="" then age_gp="z: Unknown";
if obese_overweight="" then obese_overweight="z: Unknown";
if Surgery_4w=1 then surgery4wk="Yes";
else if Surgery_4w=0 then surgery4wk="No";
else if Surgery_4w=. then surgery4wk="z: Unknown";

*combine cytotoxic drug;
if cytotoxic4wk in ("a. cytotoxic","b. no cytotoxi") then chemo_4w=1;
else if cytotoxic4wk="c. no chemo dr" then chemo_4w=0;
run;
 
proc freq data=rawdata;
tables   Radiation_4w survive_5yr_more ;
run;

proc sort data=rawdata; by cancer; run;
ods table binomial = CI_Values;
proc freq data=rawdata;
by cancer;
table death/binomial(level='1');
run;


proc sort data=rawdata; by cancer; run;
ods table binomial = CI_Values;
proc freq data=rawdata;
by cancer;
table severity/binomial(level='1');
run;

proc datasets; delete S0-S20; run;

%twoway_digital_Outcome(rawdata,cancer, 0,1,death,1 );
%twoway_digital_Outcome(rawdata,cancer, 0,1,Inpatient,2 );
%twoway_digital_Outcome(rawdata,cancer, 0,1,ICU,3);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Ventilation,4);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Oxygen_gp,5);
%twoway_digital_Outcome(rawdata,cancer, 0,1,severity,6);
%twoway_digital_Outcome(rawdata,cancer, 0,1,severity_level,0);

*independent variables;
%twoway_nominal(rawdata, cancer, 0,1, age_gp,7);
%twoway_nominal(rawdata,cancer, 0,1,gender,8);
%twoway_nominal(rawdata,cancer, 0,1,race_gp,9);
%twoway_nominal(rawdata,cancer, 0,1,Region,10);
%twoway_nominal(rawdata,cancer, 0,1,smoke_status,11);
%twoway_nominal(rawdata,cancer, 0,1,obese_overweight,12);
%twoway_nominal(rawdata,cancer, 0,1,N_comorbity_gp,13);
%twoway_nominal(rawdata,cancer, 0,1,N_Posi_Comorb_gp,14);
%twoway_nominal(rawdata,cancer, 0,1,surgery4wk,15);
%twoway_nominal(rawdata,cancer, 0,1,cancer_type,16);
%twoway_digital(rawdata,cancer, 0,1,chemo_4w,17);
%twoway_digital(rawdata,cancer, 0,1,Radiation_4w,18);
%twoway_nominal(rawdata,cancer, 0,1,age_cancer_gp,19);
%twoway_digital(rawdata,cancer, 0,1,survive_5yr_more,20);
  
 
data Table_outcome;
set S1-S6 ;
if level=0 or level="N" then delete;
id=_n_;
run;
data Table_indep;
set S7-S20;
id=_n_;
run;

proc sort data=Table_outcome; by id; run;
proc sort data=Table_indep; by id; run;


ods rtf file="Z:\8 GQ Zhang group\STEP1 data analysis\OUTPUT\Table1.rtf" startpage=never;
ods text="0. Two groups, 0 for non-cancer, 1 for cancer";
proc freq data=rawdata;
tables cancer;
run;
ods text="1. Outcomes for cancer and non-cancer groups";
proc print data=Table_outcome noobs;
var variable level cancer0 cancer1 ;
run;
proc print data=S0 noobs;
var variable level cancer0 cancer1 ;
run;
proc print data=S17 noobs;
var variable level cancer0 cancer1 ;
run;
ods text="2. Independent variables for cancer and non-cancer groups";
proc print data=Table_indep noobs;
var variable level cancer0 cancer1 ;
run;
ods rtf close;

/*
ods rtf file="Z:\8 GQ Zhang group\Manuscript\waste.rtf" startpage=never;
proc print data=Table_cancer noobs;
var variable level cancer0 cancer1 ;
run;   
ods rtf close;

proc summary data=rawdata median min max maxdec=2 print;
class cancer;
var age;
run;
