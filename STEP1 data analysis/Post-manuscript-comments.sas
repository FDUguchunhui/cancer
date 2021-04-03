*Chung;
proc freq data=rawdata;
tables cancer_type*chemo_4w/nopercent nocol;
where cancer=1 and cancer_type~="c.Multitype";
run; 
proc freq data=rawdata;
tables cancer_type*Radiation_4w/nopercent nocol;
where cancer=1 and cancer_type~="c.Multitype";
run;

proc freq data=rawdata;
tables survive_5yr_more*chemo_4w/nopercent nocol;
where cancer=1 ;
run; 
proc freq data=rawdata;
tables survive_5yr_more*Radiation_4w/nopercent nocol;
where cancer=1 ;
run;

proc means data=rawdata mean std maxdec=1 print;
class cancer_type;
var duration;
where cancer=1 and duration>0;
run;
proc freq data=rawdata;
tables cancer_type*survive_5yr_more/nopercent nocol;
where cancer=1 ;
run;
