data rawdata3; set rawdata2;
N_comorbity=sum(Chronic_Kidney_Disease,
Chronic_Obstructive_Pulmonary,Down_Syndrome,
Solid_Organ_Transplant,
obesity01,pregnancy,
Heart_Failure,Coronary_Artery_Disease, 
Cardiomyopathies,
Sickle_Cell_Disease,smoke_yn,Type_2_Diabetes_Mellitus);

N_Posi_Comorb=sum(Asthma,Cerebrovascular,Cystic_Fibrosis,
Hypertension,Other_Immuno,Liver_Disease,Dementia,
overweight01,Pulmonary_Fibrosis,Thalassemia,Type_1_Diabetes_Mellitus);

if N_comorbity>=4 then N_comorbity_gp=">=4";
else if N_comorbity=3 then N_comorbity_gp="3";
else if N_comorbity=2 then N_comorbity_gp="2"; 
else if N_comorbity=1 then N_comorbity_gp="1";
else if N_comorbity~=. then N_comorbity_gp="0";

if N_Posi_Comorb>=4 then N_Posi_Comorb_gp=">=4";
else if N_Posi_Comorb=3 then N_Posi_Comorb_gp="3";
else if N_Posi_Comorb=2 then N_Posi_Comorb_gp="2";
else if N_Posi_Comorb=1 then N_Posi_Comorb_gp="1";
else if N_Posi_Comorb~=. then N_Posi_Comorb_gp="0";


if MA_Cytotoxic_4w=1 or PS_Cytotoxic_4w=1 or PR_Cytotoxic_4w=1 then cytotoxic_4wk="Y";
else cytotoxic_4wk="N";

if MA_Non_Cytotoxic_4w=1 or PS_Non_Cytotoxic_4w=1 or PR_Non_Cytotoxic_4w=1 then Nocytotoxic_4wk="Y";
else Nocytotoxic_4wk="N";

if cytotoxic_4wk="Y" then cytotoxic4wk="a. cytotoxic  ";
else if Nocytotoxic_4wk="Y" then cytotoxic4wk="b. no cytotoxic";
else cytotoxic4wk="c. no chemo drug";

*combine cytotoxic drug;
if cytotoxic4wk in ("a. cytotoxic","b. no cytotoxi") then chemo_4w=1;
else if cytotoxic4wk="c. no chemo dr" then chemo_4w=0;

 
 run;


proc freq data=rawdata3;
tables N_comorbity_gp  N_Posi_Comorb_gp cytotoxic_4wk
Nocytotoxic_4wk cytotoxic4wk chemo_4w;
where cancer=1;
run;
/*
proc freq data=rawdata2;
tables       Chronic_Kidney_Disease 
Chronic_Obstructive_Pulmonary Down_Syndrome 
Solid_Organ_Transplant 
obesity01 pregnancy 
Heart_Failure Coronary_Artery_Disease  
Cardiomyopathies 
Sickle_Cell_Disease smoke_yn Type_2_Diabetes_Mellitus
Asthma Cerebrovascular Cystic_Fibrosis 
Hypertension Other_Immuno Liver_Disease Dementia 
overweight01 Pulmonary_Fibrosis Thalassemia Type_1_Diabetes_Mellitus
;
run;*/

data rawdata4;
set rawdata3; 
cancer_year=year(cancer_date);

age_at_cancer=(cancer_year-BIRTH_YR);

duration=(COVID_diag_date-cancer_date)/365.25;
if duration>5 then survive_5yr_more=1;
else if duration<=5 and duration>=0 then survive_5yr_more=0;
if cancer=0 then survive_5yr_more=.;

*IF the cancer occur before covid, then need to be labeled and deleted later;
if duration<0 and duration~=. then cancer_after_COVID=1;

if age_at_cancer>=0 and age_at_cancer<20 then age_cancer_gp="0-20  ";
else if age_at_cancer>=20 and age_at_cancer<40 then age_cancer_gp="20-40";
else if age_at_cancer>=40 and age_at_cancer<60 then age_cancer_gp="40-60";
else if age_at_cancer>=60 and age_at_cancer<80 then age_cancer_gp="60-80";
else if age_at_cancer>=80 then age_cancer_gp=">=80";
else age_cancer_gp="miss";

run;
proc freq data=rawdata4;
tables age_cancer_gp Radiation_4w;
where cancer=1;
run;

data rawdata5;
set rawdata4;
time_death=DATE_OF_DEATH-COVID_diag_date;
if time_death>=-15 and time_death<0 then time_death=0;*If it is within 15 days then set it as 0 (because we do not know death date but assuming mid of the month), immediately die after covid;
if time_death~=. and time_death<-15 then time_death=.; *if the value is way below 15, treat it as missing;
end_study=mdy("01","28","2021");
format end_study mmddyy10.;
 
if death=1 then T=time_death;
else if death=0 then T=(end_study-COVID_diag_date);

*if T<0 then T=.; *for those whose COVID_diag_date is over 
*For those die after 30 days, death will be changed to "0" (means no death);
T_greater_30=0;
if death=1 and time_death>30 then do; T_greater_30=1; death=0;end;

if T~=. then T_30=min(T,30);

run;
 

 proc means data=rawdata5 min print;
 var T_30;
 where death=1;
 run;

proc print data=rawdata5 (obs=20);
var death DATE_OF_DEATH COVID_diag_date  time_death T T_30;
 run;


proc freq data=rawdata4;
tables death;
run;
proc freq data=rawdata5;
tables death;
run;



data rawdata6;
set rawdata5;
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
if Region="Other/Unknown" then Region="z: Other/Unknown";
run;
 
 
proc freq data=rawdata6;
tables Cancer_dx_code cancer_2digit  ;
where cancer=1;
run;

proc freq data=rawdata6;
tables death inpatient ICU Ventilation;
run;

data rawdata7;
set rawdata6;
if death=0 and inpatient=0 and ICU=0 and Ventilation=0 then severity_level=0;
else if death=0 and inpatient=1 and ICU=0 and Ventilation=0 then severity_level=1;
else if death=1 then severity_level=3;
else if death~=. and inpatient~=. and ICU~=. and
Ventilation~=. then severity_level=2;

if death=. then delete; *in outcomes, only death has missing;
if cancer_after_COVID=1 then delete;



run;

proc freq data=rawdata7;
tables severity_level severity smoke_status;
run;

data B.rawdata;
set rawdata7;
where age>=18;
run;

