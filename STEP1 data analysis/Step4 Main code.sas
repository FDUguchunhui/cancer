libname B "Y:\Documents\cancer\data";
%include "Y:\Documents\cancer\STEP1 data analysis\Macro Freq no p value.sas";

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
data rawdata;
set B.rawdata;
if gender="Unknown" then gender="z: Unknown"; *rename to make this category appear in the last row;
if age_cancer_gp="miss" then age_cancer_gp="z: Unknown";
if age_gp="" then age_gp="z: Unknown";
if obese_overweight="" then obese_overweight="z: Unknown";
if Surgery_4w=1 then surgery4wk="Yes";
else if Surgery_4w=0 then surgery4wk="No";
else if Surgery_4w=. then surgery4wk="z: Unknown";
run;
   
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


***Appendix Table 1;
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
  
data com_indep;
set S1-S23;
id=_n_;
if level=0 then delete;
run;
proc sort data=com_indep; by id; run;

*Table 3;
data rawdata_cancer; set rawdata; where cancer=1; run;
data rawdata_nocancer; set rawdata; where cancer=0; run;

%macro one_factor(rawdata_cancer,death);
proc datasets; delete S7-S19; run;

%twoway_nominal2(&rawdata_cancer,&death, 0,1, age_gp,7);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,gender,8);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,race_gp,9);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,region,10);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,N_comorbity_gp,11);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,N_Posi_Comorb_gp,12);
%twoway_nominal2(&rawdata_cancer,&death, 0,1,surgery4wk,13);

data &rawdata_cancer.&death;
set S7-S13;
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
 
***Table 4, models;
data rawdata;
set B.rawdata;
if gender="Unknown" then gender=""; *to make missing not to participate in models;
if age_cancer_gp="miss" then age_cancer_gp="";  
if age_gp="z: Unk" then age_gp="";
run;
 
proc freq data=B.rawdata;
tables chemo_4w;
run;

data rawdata_cancer; set rawdata; where cancer=1; run;
data rawdata_nocancer; set rawdata; where cancer=0; run;
   
***MODEL 1:Cox regression;
proc phreg data=rawdata_cancer;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)  cancer_type(ref=first)
survive_5yr_more(ref=first)
chemo_4w(ref=first) 
Radiation_4w(ref=first)/ param=ref;
model T_30*death(0)=age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb
Surgery_4w
cancer_type
chemo_4w
Radiation_4w 
survive_5yr_more;
 ods output ParameterEstimates=P_cancer;
run; 

data P_cancer;
set P_cancer;
lowerCL=exp(Estimate-1.96*StdErr);
UpperCL=exp(Estimate+1.96*StdErr);
HR_cancer=trim(left(put(HazardRatio,8.2)))||"("||
trim(left(put(LowerCL,8.2)))||","||trim(left(put(UpperCL,8.2)))||")";
level=ClassVal0;
id=_n_;
keep Parameter level HR_cancer id;
run;

*non-cancer;
proc phreg data=rawdata_nocancer;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)/ param=ref;
model T_30*death(0)=age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb
Surgery_4w ;
 ods output ParameterEstimates=P_nocancer;
run; 

data P_nocancer;
set P_nocancer;
lowerCL=exp(Estimate-1.96*StdErr);
UpperCL=exp(Estimate+1.96*StdErr);
HR_noca=trim(left(put(HazardRatio,8.2)))||"("||
trim(left(put(LowerCL,8.2)))||","||trim(left(put(UpperCL,8.2)))||")";
level=ClassVal0;
id=_n_;
keep Parameter  HR_noca id;
run;

proc sort data=P_cancer; by id; run;
proc sort data=P_nocancer; by id; run;

data HRP;
merge P_cancer P_nocancer;
by id;
run;
 
***MODEL 2:logistic regression, severity, cancer;
proc logistic data=rawdata_cancer descending;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)  cancer_type(ref=first)
survive_5yr_more(ref=first)
Radiation_4w(ref=first) chemo_4w(ref=first)
/ param=ref;
model severity=age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb
Surgery_4w
cancer_type
chemo_4w
Radiation_4w 
survive_5yr_more/selection=stepwise;
ods output ParameterEstimates=Prob(where=(Variable~='Intercept') keep=
variable ProbChiSq) OddsRatios=OR(keep=effect OddsRatioEst 
LowerCL UpperCL);
run;
data Prob; set Prob; retain id 0; id=id+1; run;
data OR; set OR; retain id 0; id=id+1; run;
data ORP_cancer;merge Prob OR;by id;
OR_cancer=trim(left(put(OddsRatioEst,8.2)))||"("||
trim(left(put(LowerCL,8.2)))||","||trim(left(put(UpperCL,8.2)))||")";
drop OddsRatioEst LowerCL UpperCL;
run; 
proc datasets;delete Prob OR;quit;run;


*severity, non-cancer;
proc logistic data=rawdata_nocancer descending;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)/ param=ref;
model severity= 
age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb
Surgery_4w  /selection=stepwise;
ods output ParameterEstimates=Prob(where=(Variable~='Intercept') keep=
variable ProbChiSq) OddsRatios=OR(keep=effect OddsRatioEst 
LowerCL UpperCL);
run;
data Prob; set Prob; retain id 0; id=id+1; run;
data OR; set OR; retain id 0; id=id+1; run;
data ORP_nocancer;merge Prob OR;by id;
OR_nocancer=trim(left(put(OddsRatioEst,8.2)))||"("||
trim(left(put(LowerCL,8.2)))||","||trim(left(put(UpperCL,8.2)))||")";
drop OddsRatioEst LowerCL UpperCL;
run; 
proc datasets;delete Prob OR;quit;run;

proc sort data=ORP_cancer; by id; run;
proc sort data=ORP_nocancer; by id; run;

data ORP_both;
merge ORP_cancer ORP_nocancer;
by id;
run;
***MODEL 3: Multinomial model;
*severity, cancer;
proc logistic data=rawdata_cancer descending;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)  cancer_type(ref=first)
survive_5yr_more(ref=first)
chemo_4w(ref=first)
Radiation_4w(ref=first) / param=ref;
model  severity_level=age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb
Surgery_4w
cancer_type
chemo_4w
Radiation_4w 
survive_5yr_more/link=glogit;
ods output ParameterEstimates=Prob(where=(Variable~='Intercept')) OddsRatios=OR;
run;
data Prob; set Prob; retain id 0; id=id+1; run;
data OR; set OR; retain id 0; id=id+1; run;
data MNP_cancer;merge Prob OR;by id;
MN_cancer=trim(left(put(OddsRatioEst,8.2)))||"("||
trim(left(put(LowerCL,8.2)))||","||trim(left(put(UpperCL,8.2)))||")";
drop OddsRatioEst LowerCL UpperCL;
run; 
proc datasets;delete Prob OR;quit;run;


*severity, non-cancer;
proc logistic data=rawdata_nocancer descending;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first) / param=ref;
model severity_level =age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb
Surgery_4w/link=glogit;
ods output ParameterEstimates=Prob(where=(Variable~='Intercept')) OddsRatios=OR ;
run;
data Prob; set Prob; retain id 0; id=id+1; run;
data OR; set OR; retain id 0; id=id+1; run;
data MNP_nocancer;merge Prob OR;by id;
MN_nocancer=trim(left(put(OddsRatioEst,8.2)))||"("||
trim(left(put(LowerCL,8.2)))||","||trim(left(put(UpperCL,8.2)))||")";
drop OddsRatioEst LowerCL UpperCL;
run; 
proc datasets;delete Prob OR;quit;run;

proc sort data=MNP_cancer; by id; run;
proc sort data=MNP_nocancer; by id; run;

data MNP_cancer1; set MNP_cancer; where Response="1"; MN_cancer1=MN_cancer; nid=_n_; run;
data MNP_cancer2; set MNP_cancer; where Response="2"; MN_cancer2=MN_cancer; nid=_n_;run;
data MNP_cancer3; set MNP_cancer; where Response="3"; MN_cancer3=MN_cancer; nid=_n_;run;
 
data MNP_nocancer1; set MNP_nocancer; where Response="1"; MN_nocancer1=MN_nocancer; nid=_n_;run;
data MNP_nocancer2; set MNP_nocancer; where Response="2"; MN_nocancer2=MN_nocancer; nid=_n_;run;
data MNP_nocancer3; set MNP_nocancer; where Response="3"; MN_nocancer3=MN_nocancer; nid=_n_;run;
 
proc sort data=MNP_cancer1; by nid; run;
proc sort data=MNP_cancer2; by nid; run;
proc sort data=MNP_cancer3; by nid; run;
 
proc sort data=MNP_nocancer1; by nid; run;
proc sort data=MNP_nocancer2; by nid; run;
proc sort data=MNP_nocancer3; by nid; run;

data MNP;
merge MNP_cancer1 MNP_cancer2 MNP_cancer3  
MNP_nocancer1 MNP_nocancer2 MNP_nocancer3 ;
by nid;
run;

*Export data to do matching;
data DATA_FOR_MATCHING;
set B.rawdata;
keep Patient_ID cancer  GENDER   REGION age            
race_gp N_comorbity N_Posi_Comorb  
;
if Patient_ID="" 
or  GENDER="Unknown" or     
REGION="z: Other/Unkn"      
or  age=. or cancer=.  or   
N_comorbity=. or N_Posi_Comorb=. then delete; *delete missing except race because other and missing are mixed and there's a lot;
run;

proc freq data= DATA_FOR_MATCHING; *double check to make sure no missing;
table cancer  GENDER   REGION             
race_gp;
run;
proc means data=DATA_FOR_MATCHING nmiss;
var age N_comorbity N_Posi_Comorb;
run;

PROC EXPORT DATA= WORK.DATA_FOR_MATCHING 
            OUTFILE= "Z:\8 GQ Zhang group\Organized Code\Before_matching.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN; 

*SWITCH TO R to perform matching;

*matched data;
PROC IMPORT OUT= WORK.after_match
            DATAFILE= "Z:\8 GQ Zhang group\Organized Code\matched_cancer_geq_18.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data match_ID;
set after_match;
match_indicator=1;
keep patient_ID match_indicator;
run;

proc sort data=B.rawdata; by patient_ID; run;
proc sort data=match_ID; by patient_ID; run;
data merged;
merge B.rawdata match_ID;
by patient_ID;
run;

data matched;
set merged;
where match_indicator=1;
run;
   
proc freq data=matched; 
tables cancer;
run;
proc datasets; delete S1-S6; run;

%twoway_digital_Outcome(matched,cancer, 0,1,death,1 );
%twoway_digital_Outcome(matched,cancer, 0,1,Inpatient,2 );
%twoway_digital_Outcome(matched,cancer, 0,1,ICU,3);
%twoway_digital_Outcome(matched,cancer, 0,1,Ventilation,4);
%twoway_digital_Outcome(matched,cancer, 0,1,severity,5);
%twoway_digital_Outcome(matched,cancer, 0,1,severity_level,6);
 
data Table_outcome_matched;
set S1-S5;
if level=0 or level="N" then delete;
id=_n_;
run;
data Table_outcome_matched;
set Table_outcome_matched S6;
run;

proc phreg data=matched;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)  
/ param=ref;
model T_30*death(0)=cancer age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb
Surgery_4w;
 ods output ParameterEstimates=P_cox; 
run; 

data P_cox;
set p_cox; 
lowerCL=exp(Estimate-1.96*StdErr);
UpperCL=exp(Estimate+1.96*StdErr);
HR=trim(left(put(HazardRatio,8.2)))||"("||
trim(left(put(LowerCL,8.2)))||","||trim(left(put(UpperCL,8.2)))||")";
level=ClassVal0;
id=_n_;
pvalue_Cox=ProbChiSq;
keep Parameter level HR id pvalue_Cox;
run;


*severity, cancer;
proc logistic data=matched descending;
class  cancer(ref=first) age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)   / param=ref;
model severity=cancer age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb 
Surgery_4w
 /selection=stepwise;
ods output ParameterEstimates=Prob(where=(Variable~='Intercept') keep=
variable ProbChiSq) OddsRatios=OR(keep=effect OddsRatioEst 
LowerCL UpperCL);
run;
data Prob; set Prob; retain id 0; id=id+1; run;
data OR; set OR; retain id 0; id=id+1; run;
data ORP;merge Prob OR;by id;
OR=trim(left(put(OddsRatioEst,8.2)))||"("||
trim(left(put(LowerCL,8.2)))||","||trim(left(put(UpperCL,8.2)))||")";
drop OddsRatioEst LowerCL UpperCL;
pvalue_logit=ProbChiSq;
run; 
proc datasets;delete Prob OR;quit;run;


proc sort data=P_COX; by id; run;
proc sort data=ORP; by id; run;
 
data model_Match;
merge  P_cox ORP;
by id;
format pvalue_logit pvalue_Cox 8.3;
run;

*Calculate some CIs;

%macro findCI(rawdata,death,id);
proc sort data=&rawdata; by cancer; run;
ods table binomial = CI_Values;
proc freq data=&rawdata;
by cancer;
table &death/binomial(level="1");
ods output Binomial=B;
run; 
data B_&id;
set B;
where Name1 in ("_BIN_","L_BIN","U_BIN");
if Name1="_BIN_" then name1="Percent";
if Name1="L_BIN" then name1="Low";
if Name1="U_BIN" then name1="Upper";
pct=nvalue1*100;
format pct 6.2;
var="&death";
keep var cancer  Name1 pct;
run; 
%mend;
%findCI(rawdata,death,1);
%findCI(rawdata,inpatient,2);
%findCI(rawdata,ICU,3);
%findCI(rawdata,ventilation,4);
%findCI(rawdata,severity,5);
%findCI(matched,death,6);
%findCI(matched,inpatient,7);
%findCI(matched,ICU,8);
%findCI(matched,ventilation,9);
%findCI(matched,severity,10);



options orientation=landscape;
ods rtf file="Z:\8 GQ Zhang group\Organized Code\All tables.rtf" startpage=never;
ods text="0. Two groups, 0 for non-cancer, 1 for cancer";
proc freq data=rawdata;
tables cancer;
run;
ods text="Table 1. Independent variables for cancer and non-cancer groups";
proc print data=Table_indep noobs;
var variable level cancer0 cancer1 ;
run;
ods text="Table 2. Outcomes for cancer and non-cancer groups";
proc print data=Table_outcome noobs;
var variable level cancer0 cancer1 ;
run; 
ods text="Table 3. Outcomes for cancer and non-cancer groups"; 
proc print data=Table3 noobs;
var variable	Level	
 inpatient1_noca	Ventilation1_noca	ICU1_noca death1_noca	
inpatient1 Ventilation1	ICU1	death1;
run; 

ods text="Table 4. Cox model for death";
proc print data=HRP noobs;
var Parameter level  HR_noca HR_cancer;
run;
ods text="Table 4. logistic model for severity";
proc print data=ORP_both noobs;
var variable Effect OR_nocancer OR_cancer ;
run;
ods text="Table 5. multinomial model for severity";
proc print data=MNP noobs;
var Variable effect
MN_nocancer1 MN_nocancer2 MN_nocancer3 
MN_cancer1 MN_cancer2 MN_cancer3;
run;
ods text="Table 6. matched data's outcome";
proc print data=Table_outcome_matched noobs;
var variable level cancer0 cancer1 ;
run; 
ods text="Table 7: matched data regression model";
proc print data=model_Match noobs;
var Variable effect HR pvalue_Cox OR pvalue_logit; 
run; 

ods text="Table A.1 Comorbidities for cancer and non-cancer groups";
proc print data=Com_indep noobs;
var  variable level cancer0 cancer1 ;
run;  

ods text="median ages";
proc means data=rawdata n median Q1 Q3 maxdec=0 print;
class cancer;
var age;
run;


ods text="mean number of comorbidities";
proc means data=rawdata n mean std maxdec=1 print;
class cancer;
var N_comorbity
;
run;
proc means data=rawdata n mean std maxdec=1 print;
class cancer;
var
N_Posi_Comorb 
;
run;


ods text="rawdata 95%CI";
proc print data=B_1; run;
proc print data=B_2; run;
proc print data=B_3; run;
proc print data=B_4; run;
proc print data=B_5; run;
ods text="matched data 95%CI";
proc print data=B_6; run;
proc print data=B_7; run;
proc print data=B_8; run;
proc print data=B_9; run;
proc print data=B_10; run;

ods rtf close;
 
data alltime;
set B.rawdata;
keep cancer T_30 death;
run;
PROC EXPORT DATA= WORK.alltime  
            OUTFILE= "Z:\8 GQ Zhang group\Organized Code\alltime.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
 
data matched_data;
set matched;
keep cancer T_30  death;
run;
PROC EXPORT DATA= WORK.matched_data  
            OUTFILE= "Z:\8 GQ Zhang group\Organized Code\matched_data.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
  
