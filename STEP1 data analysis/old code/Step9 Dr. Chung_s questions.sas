/*Dr. Chung's question;
1.	The age distribution of solid tumor and hematological malignancy patients
2.	The race distribution of patients with cancer after COVID 19 (not sure about this one, please double-check with your notes)
3.	Age-gender analysis
4.	Gender-comorbidities analysis
5.	Chemotherapy analysis for patient with survival years > 5 years
*/

data rawdata; set B.rawdata; *combine cytotoxic drug;
if cytotoxic4wk in ("a. cytotoxic","b. no cytotoxi") then chemo_4w=1;
else if cytotoxic4wk="c. no chemo dr" then chemo_4w=0;
 run; 

*Q1;
*Q2;
data raw1;
set B.rawdata0;
run; 
data raw1_exclude;
set raw1;
where COVID_diag_date<cancer_date;
if ETHNICITY="Not Hispanic" and RACE="Caucasian" then race_gp="Non-hispanic white";
else if ETHNICITY="Not Hispanic" and RACE="African American" then race_gp="Non-hispanic black";
else if ETHNICITY="Hispanic" then race_gp="Hispanic";
else race_gp="Others/Unknown";

COVID_year=year(COVID_diag_date);
age=(covid_year-birth_yr);

if age>=0 and age<50 then age_gp="0-50  ";
else if age>=50 and age<65 then age_gp="50-65";
else if age>=65 and age<80 then age_gp="65-80";
else if age>=80 then age_gp=">=80";



cancer_2digit=substr(Cancer_dx_code,1,3);

if cancer_2digit
in ("C10",
"C11",
"C12",
"C13",
"C14",
"C15",
"C16",
"C17",
"C18",
"C19",
"C20",
"C21",
"C22",
"C23",
"C24",
"C25",
"C26",
"C30",
"C31",
"C32",
"C33",
"C34",
"C37",
"C38",
"C39",
"C40",
"C41",
"C43",
"C45",
"C46",
"C47",
"C48",
"C49",
"C50",
"C51",
"C52",
"C53",
"C54",
"C55",
"C56",
"C57",
"C58",
"C60",
"C61",
"C62",
"C63",
"C64",
"C65",
"C66",
"C67",
"C68",
"C69",
"C70",
"C71",
"C72",
"C73",
"C74",
"C75" 
) then cancer_type="a. solid    ";
else if cancer_2digit in ("C81",
"C82",
"C83",
"C84",
"C85",
"C88",
"C90",
"C91",
"C92",
"C93",
"C94",
"C95",
"C96"
) then cancer_type="b. liquid";
else if cancer_2digit="C76" then cancer_type="c.Multitype";
run;



*Q4;
%include "Z:\8 GQ Zhang group\STEP1 data analysis\Macro Freq no p value.sas";
data rawdata; set rawdata; 
if gender="Female" then gender01=0;
else if gender="Male" then gender01=1;
run;

data rawdata_cancer; set rawdata; where cancer=1; run;
data rawdata_nocancer; set rawdata; where cancer=0; run;

proc datasets; delete S1-S23; run;
%twoway_digital_Outcome(rawdata_cancer, gender01, 0,1,Chronic_Kidney_Disease,1);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Chronic_Obstructive_Pulmonary,2);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Down_Syndrome,3);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Solid_Organ_Transplant,4);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,obesity01,5);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,pregnancy,6);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Heart_Failure,7);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Coronary_Artery_Disease,8);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Cardiomyopathies,9);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Sickle_Cell_Disease,10);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,smoke_yn,11);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Type_2_Diabetes_Mellitus,12); 
%twoway_digital_Outcome(rawdata_cancer, gender01, 0,1,Asthma,13);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Cerebrovascular,14);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Cystic_Fibrosis,15);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Hypertension,16);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Other_Immuno,17);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Liver_Disease,18);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Dementia,19);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,overweight01,20);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Pulmonary_Fibrosis,21);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Thalassemia,22);
%twoway_digital_Outcome(rawdata_cancer,gender01, 0,1,Type_1_Diabetes_Mellitus,23); 
data cancer_morb;
set S1-S23;
id=_n_/2;
if level=0 then delete;
male=gender011;
female=gender010;
run;
proc sort data=cancer_morb; by id; run;


proc datasets; delete S1-S23; run;
%twoway_digital_Outcome(rawdata_nocancer, gender01, 0,1,Chronic_Kidney_Disease,1);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Chronic_Obstructive_Pulmonary,2);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Down_Syndrome,3);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Solid_Organ_Transplant,4);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,obesity01,5);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,pregnancy,6);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Heart_Failure,7);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Coronary_Artery_Disease,8);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Cardiomyopathies,9);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Sickle_Cell_Disease,10);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,smoke_yn,11);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Type_2_Diabetes_Mellitus,12); 
%twoway_digital_Outcome(rawdata_nocancer, gender01, 0,1,Asthma,13);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Cerebrovascular,14);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Cystic_Fibrosis,15);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Hypertension,16);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Other_Immuno,17);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Liver_Disease,18);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Dementia,19);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,overweight01,20);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Pulmonary_Fibrosis,21);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Thalassemia,22);
%twoway_digital_Outcome(rawdata_nocancer,gender01, 0,1,Type_1_Diabetes_Mellitus,23); 
data nocancer_morb;
set S1-S23;
id=_n_/2;
if level=0 then delete;
male=gender011;
female=gender010;
run;
proc sort data=nocancer_morb; by id; run;


ods rtf file="Z:\8 GQ Zhang group\STEP1 data analysis\OUTPUT\Dr Chung questions.rtf" startpage=no;
ods text="Q1: The age distribution of solid tumor and hematological malignancy patients";
proc summary data=rawdata mean std min max Q1 Q3 maxdec=1 print;
class cancer_type;
var age;
where cancer=1;
run;
proc freq data=rawdata;
tables age_gp*cancer_type/nopercent norow;
where cancer=1;
run;

ods text="Q2: The race distribution of patients with cancer after COVID 19";
proc freq data=raw1_exclude;
tables race_gp age_gp cancer_type;
run; 

ods text="Q3: Age-gender analysis";
proc sort data=rawdata; by cancer; run;
ods text="No cancer";
proc summary data=rawdata mean std min max Q1 Q3 maxdec=1 print;
class gender;
var age;
where cancer=0;
run;
ods text="cancer";
proc summary data=rawdata mean std min max Q1 Q3 maxdec=1 print;
class gender;
var age;
where cancer=1;
run;
proc freq data=rawdata;
tables gender*age_gp/nopercent nocol;
by cancer;
run;

ods text="Q4: Gender-comorbidities analysis";
ods text="Cancer";
proc print data=cancer_morb noobs;
var id variable male female ;
run;   
ods text="No cancer";
proc print data=nocancer_morb noobs;
var id variable male female ;
run;   

*Q5;
ods text="Q5: chemotherapy analysis for survivors over 5 years";
proc freq data=rawdata;
tables survive_5yr_more*chemo_4w/nopercent nocol;
run;
ods rtf close;
