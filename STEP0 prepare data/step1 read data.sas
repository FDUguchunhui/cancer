libname B "Z:\8 GQ Zhang group";
/*PROC IMPORT OUT= B.RAWDATA_old 
            DATAFILE= "Z:\8 GQ Zhang group\STEP0 prepare data\Cancer_cov
id_20210315.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Cancer_covid_20210315$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

data B.rawdata_old;
set B.rawdata_old;
drop MA_Cytotoxic_4w
MA_Non_Cytotoxic_4w
PR_Cytotoxic_4w
PR_Non_Cytotoxic_4w
PS_Cytotoxic_4w
PS_Non_Cytotoxic_4w
Radiation_4w
Surgery_4w;
run;

PROC IMPORT OUT= B.recent 
            DATAFILE= "Z:\8 GQ Zhang group\STEP0 prepare data\Cancer_covid_20210319_addtional.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Cancer_covid_20210319_addtional$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

proc sort data=B.rawdata_old; by Patient_ID; run;
proc sort data=B.recent; by Patient_ID; run;

data B.rawdata0;
merge B.rawdata_old(in=a) B.recent;
by Patient_ID;
if a;
run;
*/
  
data rawdata1;
set B.rawdata0;
if ETHNICITY="Not Hispanic" and RACE="Caucasian" then race_gp="Non-hispanic white";
else if ETHNICITY="Not Hispanic" and RACE="African American" then race_gp="Non-hispanic black";
else if ETHNICITY="Hispanic" then race_gp="Hispanic";
else race_gp="Others/Unknown";

if smoke in ("Current smoker") then smoke_status="a:current";
else if smoke in ("Previously smoked") then smoke_status="b:former";
else if smoke in ("N","Never smoked") then smoke_status="c:never";
else if smoke in ("Not recorded", "Other smoking status","Not currently smoking","Unknown smoking status","") then smoke_status="d:Other/unknown";
  
*try to fill in some missing by ICD smoke;
if smoke in ("Not recorded", "Other smoking status","Not currently smoking","Unknown smoking status","") and Smoke_by_ICD=1 and Smoke_by_ICD_group="current" then smoke_status="a:current";
if smoke in ("Not recorded", "Other smoking status","Not currently smoking","Unknown smoking status","") and Smoke_by_ICD=1 and Smoke_by_ICD_group="former" then smoke_status="b:former";
 
if smoke_status in ("a:current","b:former") then smoke_yn=1;
else if smoke_status not in ("d:Other/unknown") then smoke_yn=0;


death=DECEASED_INDICATOR; 
inpatient=Inpatient_visit;

if death=1 or inpatient=1 or ICU=1 or Ventilation=1 then severity=1;
else if death~=. and inpatient~=. and ICU~=. and
Ventilation~=. then severity=0;

event_count=death+inpatient+ICU+Ventilation;
 
COVID_year=year(COVID_diag_date);
age=(covid_year-birth_yr);
if age>=0 and age<18 then age_gp="0-18  ";
else if age>=18 and age<50 then age_gp="18-50";
else if age>=50 and age<65 then age_gp="50-65";
else if age>=65 and age<75 then age_gp="65-75";
else if age>=75 then age_gp=">=75";

run;
  
