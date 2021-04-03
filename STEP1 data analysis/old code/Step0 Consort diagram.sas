proc contents data=B.rawdata0;
run;

*delete outcome missing: no missing;
data raw1;
set B.rawdata0;
where DECEASED_INDICATOR~=. and Inpatient_visit~=. and ICU~=. and Ventilation~=.;
run;
proc freq data=B.rawdata0;
tables DECEASED_INDICATOR;
run;

data raw1_exclude;
set raw1;
where COVID_diag_date<cancer_date;
run;

data raw2;
set raw1;
where COVID_diag_date>=cancer_date;
run;

proc freq data=raw2;
tables cancer;
run;


