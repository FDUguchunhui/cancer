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

*combine cytotoxic drug;
if cytotoxic4wk in ("a. cytotoxic","b. no cytotoxi") then chemo_4w=1;
else if cytotoxic4wk="c. no chemo dr" then chemo_4w=0;

run;

data rawdata_cancer; set rawdata; where cancer=1; run;
data rawdata_nocancer; set rawdata; where cancer=0; run;

proc freq data=rawdata_cancer; tables death;run;
proc freq data=rawdata_nocancer; tables death;run;


%macro one_factor(rawdata_cancer,death);
proc datasets; delete S7-S19; run;

%twoway_nominal2(&rawdata_cancer,&death, 0,1, age_gp,7);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,gender,8);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,race_gp,9);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,region,10);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,smoke_status,11);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,obese_overweight,12);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,N_comorbity_gp,13);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,N_Posi_Comorb_gp,14);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,surgery4wk,15);

data &rawdata_cancer.&death;
set S7-S15;
drop total;
id=_n_;
keep id variable level &death.1;
run;
proc sort data=&rawdata_cancer.&death; by id; run;
%mend;

%one_factor(rawdata_cancer,death);
%one_factor(rawdata_cancer,ICU);
%one_factor(rawdata_cancer,Ventilation); 
%one_factor(rawdata_cancer,inpatient); 
 
data within_cancer;
merge rawdata_cancerdeath 
rawdata_cancerICU rawdata_cancerVentilation
rawdata_cancerinpatient;
by id;
run; 

%one_factor(rawdata_nocancer,death);
%one_factor(rawdata_nocancer,ICU);
%one_factor(rawdata_nocancer,Ventilation); 
%one_factor(rawdata_nocancer,inpatient); 
 
data within_nocancer;
merge rawdata_nocancerdeath  
rawdata_nocancerICU rawdata_nocancerVentilation
rawdata_nocancerinpatient;
by id;
death1_noca= death1;
ICU1_noca=ICU1;
Ventilation1_noca=Ventilation1;
inpatient1_noca= inpatient1;

drop death1 inpatient1 ICU1 Ventilation1;
run; 

data Table3_part1;
merge within_cancer within_nocancer;
by id;
run;


%macro one_factor_cancer(death);
proc datasets; delete S16-S20; run;
%twoway_nominal2(rawdata_cancer,&death, 0,1,cancer_type,16);
%twoway_digital2(rawdata_cancer,&death, 0,1,chemo_4w,17);
%twoway_digital2(rawdata_cancer,&death, 0,1,Radiation_4w,18);
%twoway_nominal2(rawdata_cancer,&death, 0,1,age_cancer_gp,19);
%twoway_digital2(rawdata_cancer,&death, 0,1,survive_5yr_more,20);

data cancer_&death;
set S16-S20;
drop total;
id=_n_;
keep id variable level &death.1;
run;
proc sort data=cancer_&death; by id; run;
%mend;


%one_factor_cancer(death);
%one_factor_cancer(ICU);
%one_factor_cancer(Ventilation); 
%one_factor_cancer(inpatient); 
 
data Table3_part2;
merge cancer_death  
cancer_ICU cancer_Ventilation
cancer_inpatient;
by id;  
run; 

data Table3_part1;
merge within_cancer within_nocancer;
by id;
run;

data Table3;
set Table3_part1 Table3_part2;
run;

options orientation=landscape;
ods rtf file="Z:\8 GQ Zhang group\Manuscript\Table3new.rtf" startpage=never;
ods text="Cancer patients only";
proc print data=Table3 noobs;
var variable	Level	
 inpatient1_noca	Ventilation1_noca	ICU1_noca death1_noca	
inpatient1 Ventilation1	ICU1	death1;
run; 
ods rtf close;


proc freq data=rawdata_nocancer;
tables inpatient Ventilation ICU death/nocum;
run; 

proc freq data=rawdata_cancer;
tables inpatient Ventilation ICU death/nocum;
run;
