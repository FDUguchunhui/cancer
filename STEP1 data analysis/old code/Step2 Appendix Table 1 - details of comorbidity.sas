libname B "Z:\8 GQ Zhang group";
%include "Z:\8 GQ Zhang group\STEP1 data analysis\Macro Freq no p value.sas";

 
data rawdata;
set B.rawdata;
if gender="Unknown" then gender="z: Unknown";
if age_cancer_gp="miss" then age_cancer_gp="z: Unknown";
if age_gp="" then age_gp="z: Unknown";
if obese_overweight="" then obese_overweight="z: Unknown";
if Surgery_4w=1 then surgery4wk="Yes";
else if Surgery_4w=0 then surgery4wk="No";
else if Surgery_4w=. then surgery4wk="z: Unknown";
if cytotoxic_4wk="" then cytotoxic_4wk="z: Unknown";
 run;
 
 
proc freq data=rawdata;
tables cancer;
run;
   
 

proc datasets; delete S1-S23; run;
*independent variables;
%twoway_digital_Outcome(rawdata, cancer, 0,1,Chronic_Kidney_Disease,1);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Chronic_Obstructive_Pulmonary,2);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Down_Syndrome,3);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Solid_Organ_Transplant,4);
%twoway_digital_Outcome(rawdata,cancer, 0,1,obesity01,5);
%twoway_digital_Outcome(rawdata,cancer, 0,1,pregnancy,6);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Heart_Failure,7);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Coronary_Artery_Disease,8);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Cardiomyopathies,9);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Sickle_Cell_Disease,10);
%twoway_digital_Outcome(rawdata,cancer, 0,1,smoke_yn,11);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Type_2_Diabetes_Mellitus,12); 
%twoway_digital_Outcome(rawdata, cancer, 0,1,Asthma,13);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Cerebrovascular,14);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Cystic_Fibrosis,15);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Hypertension,16);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Other_Immuno,17);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Liver_Disease,18);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Dementia,19);
%twoway_digital_Outcome(rawdata,cancer, 0,1,overweight01,20);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Pulmonary_Fibrosis,21);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Thalassemia,22);
%twoway_digital_Outcome(rawdata,cancer, 0,1,Type_1_Diabetes_Mellitus,23); 
  
data Table_indep;
set S1-S23;
id=_n_;
if level=0 then delete;
run;

proc sort data=Table_indep; by id; run;


ods rtf file="Z:\8 GQ Zhang group\STEP1 data analysis\OUTPUT\Appendix_Table1.rtf" startpage=never;
ods text="1. Outcomes for cancer and non-cancer groups";
proc print data=Table_indep noobs;
var  variable level cancer0 cancer1 ;
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
