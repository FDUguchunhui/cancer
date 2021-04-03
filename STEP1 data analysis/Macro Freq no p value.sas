%macro twoway_digital_Outcome(dataname,colvariable,collevel1,collevel2,rowvariable,id);
proc datasets;
delete freq0 freq1 freq2 
col0 col1 col2 
freqtable ChiSq FishersExact chisq_p fisher_p min_cellcount;
run;
proc freq data=&dataname;
tables &ROWVARIABLE; 
ods output OneWayFreqs=freq1;
run;  
proc freq data=&dataname; 
tables  &ROWVARIABLE*&COLVARIABLE;
ods output crosstabfreqs=freq2 ;
run; 
 
proc sort data=freq2 ;
by &ROWVARIABLE;
run; 
    
data col1;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel1 and &ROWVARIABLE~=.;
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel1=frequency||" ("||trim(left(put(ColPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel1="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel1;
run;

data col2;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel2 and &ROWVARIABLE~=.;
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel2=frequency||" ("||trim(left(put(ColPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel2="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel2;
run;
 
data col0;  
set freq1; Total=frequency||" ("||trim(left(put(Percent,8.1)))||"%"||")"; 
keep &ROWVARIABLE Total; 
run;

proc sort data=col0; by &ROWVARIABLE; run;
proc sort data=col1; by &ROWVARIABLE; run;
proc sort data=col2; by &ROWVARIABLE; run; 

data freqtable; 
merge col0 col1  col2;  
by &ROWVARIABLE; 
run; 
data freqtable; set freqtable; order=_n_; run;

 
data S&id;
length Variable $60 Level $60;
set freqtable ;
by order;
Level=&ROWVARIABLE;
Variable="&ROWVARIABLE"||", n(%)";
keep Variable Level Total &COLVARIABLE&collevel1 &COLVARIABLE&collevel2;
run;

proc print data=S&id;
run;
%mend;

%macro twoway_nominal_Outcome(dataname,colvariable,collevel1,collevel2,rowvariable,id);
proc datasets;
delete freq0 freq1 freq2 
col0 col1 col2 
freqtable ChiSq FishersExact chisq_p fisher_p min_cellcount;
run;
proc freq data=&dataname;
tables &ROWVARIABLE; 
ods output OneWayFreqs=freq1;
run;  
proc freq data=&dataname; 
tables  &ROWVARIABLE*&COLVARIABLE;
ods output crosstabfreqs=freq2 ;
run; 
 
proc sort data=freq2 ;
by &ROWVARIABLE;
run; 
    
data col1;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel1 and &ROWVARIABLE~="";
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel1=frequency||" ("||trim(left(put(ColPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel1="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel1;
run;

data col2;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel2 and &ROWVARIABLE~="";
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel2=frequency||" ("||trim(left(put(ColPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel2="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel2;
run;
 
data col0;  
set freq1; Total=frequency||" ("||trim(left(put(Percent,8.1)))||"%"||")"; 
keep &ROWVARIABLE Total; 
run;

proc sort data=col0; by &ROWVARIABLE; run;
proc sort data=col1; by &ROWVARIABLE; run;
proc sort data=col2; by &ROWVARIABLE; run; 

data freqtable; 
merge col0 col1  col2;  
by &ROWVARIABLE; 
run; 
data freqtable; set freqtable; order=_n_; run;

  

data S&id;
length Variable $60 Level $60;
set freqtable ;
by order; 
Level=&ROWVARIABLE;
Variable="&ROWVARIABLE"||", n(%)";
/*if _n_ ne 1 then do; Variable="     "||level; pvalue=.; end; */
keep Variable Level Total &COLVARIABLE&collevel1 &COLVARIABLE&collevel2;

proc print data=S&id;
run;
%mend;

%macro twoway_digital(dataname,colvariable,collevel1,collevel2,rowvariable,id);
proc datasets;
delete freq0 freq1 freq2 
col0 col1 col2 
freqtable ChiSq FishersExact chisq_p fisher_p min_cellcount;
run;
proc freq data=&dataname;
tables &ROWVARIABLE; 
ods output OneWayFreqs=freq1;
run;  
proc freq data=&dataname; 
tables  &ROWVARIABLE*&COLVARIABLE;
ods output crosstabfreqs=freq2 ;
run; 
 
proc sort data=freq2 ;
by &ROWVARIABLE;
run; 
    
data col1;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel1 and &ROWVARIABLE~=.;
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel1=frequency||" ("||trim(left(put(ColPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel1="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel1;
run;

data col2;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel2 and &ROWVARIABLE~=.;
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel2=frequency||" ("||trim(left(put(ColPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel2="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel2;
run;
 
data col0;  
set freq1; Total=frequency||" ("||trim(left(put(Percent,8.1)))||"%"||")"; 
keep &ROWVARIABLE Total; 
run;

proc sort data=col0; by &ROWVARIABLE; run;
proc sort data=col1; by &ROWVARIABLE; run;
proc sort data=col2; by &ROWVARIABLE; run; 

data freqtable; 
merge col0 col1  col2;  
by &ROWVARIABLE; 
run; 
data freqtable; set freqtable; order=_n_; run;

 
data S&id;
length Variable $60 Level $60;
set freqtable ;
by order;
Level=&ROWVARIABLE;
Variable="&ROWVARIABLE"||", n(%)";
if _n_ ne 1 then do; Variable="     "||level; pvalue="  "; end; 
keep Variable Level Total &COLVARIABLE&collevel1 &COLVARIABLE&collevel2;
run;

data empty;
order=0; variable="&ROWVARIABLE"||", n(%)";
run;

data S&id; set empty S&id; run;
proc print data=S&id;
run;
 
%mend;

%macro twoway_nominal(dataname,colvariable,collevel1,collevel2,rowvariable,id);
proc datasets;
delete freq0 freq1 freq2 
col0 col1 col2 
freqtable ChiSq FishersExact chisq_p fisher_p min_cellcount;
run;
proc freq data=&dataname;
tables &ROWVARIABLE; 
ods output OneWayFreqs=freq1;
run;  
proc freq data=&dataname; 
tables  &ROWVARIABLE*&COLVARIABLE;
ods output crosstabfreqs=freq2 ;
run; 
 
proc sort data=freq2 ;
by &ROWVARIABLE;
run; 
    
data col1;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel1 and &ROWVARIABLE~="";
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel1=frequency||" ("||trim(left(put(ColPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel1="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel1;
run;

data col2;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel2 and &ROWVARIABLE~="";
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel2=frequency||" ("||trim(left(put(ColPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel2="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel2;
run;
 
data col0;  
set freq1; Total=frequency||" ("||trim(left(put(Percent,8.1)))||"%"||")"; 
keep &ROWVARIABLE Total; 
run;

proc sort data=col0; by &ROWVARIABLE; run;
proc sort data=col1; by &ROWVARIABLE; run;
proc sort data=col2; by &ROWVARIABLE; run; 

data freqtable; 
merge col0 col1  col2;  
by &ROWVARIABLE; 
run; 
data freqtable; set freqtable; order=_n_; run;

  

data S&id;
length Variable $60 Level $60;
set freqtable ;
by order; 
Level=&ROWVARIABLE;
Variable="&ROWVARIABLE"||", n(%)";
if _n_=1 then do; Variable="&ROWVARIABLE"||", n(%)"; end;
if _n_>1 then Variable="";  
/*if _n_ ne 1 then do; Variable="     "||level; pvalue=.; end; */
keep Variable Level Total &COLVARIABLE&collevel1 &COLVARIABLE&collevel2;

data empty;
order=0; variable="&ROWVARIABLE"||", n(%)";
run;

data S&id; set empty S&id; run;
proc print data=S&id;
run;
 
%mend;


%macro twoway_nominal2(dataname,colvariable,collevel1,collevel2,rowvariable,id);
proc datasets;
delete freq0 freq1 freq2 
col0 col1 col2 
freqtable ChiSq FishersExact chisq_p fisher_p min_cellcount;
run;
proc freq data=&dataname;
tables &ROWVARIABLE; 
ods output OneWayFreqs=freq1;
run;  
proc freq data=&dataname; 
tables  &ROWVARIABLE*&COLVARIABLE;
ods output crosstabfreqs=freq2 ;
run; 
 
proc sort data=freq2 ;
by &ROWVARIABLE;
run; 
    
data col1;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel1 and &ROWVARIABLE~="";
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel1=frequency||" ("||trim(left(put(RowPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel1="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel1;
run;

data col2;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel2 and &ROWVARIABLE~="";
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel2=frequency||" ("||trim(left(put(RowPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel2="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel2;
run;
 
data col0;  
set freq1; Total=frequency||" ("||trim(left(put(Percent,8.1)))||"%"||")"; 
keep &ROWVARIABLE Total; 
run;

proc sort data=col0; by &ROWVARIABLE; run;
proc sort data=col1; by &ROWVARIABLE; run;
proc sort data=col2; by &ROWVARIABLE; run; 

data freqtable; 
merge col0 col1  col2;  
by &ROWVARIABLE; 
run; 
data freqtable; set freqtable; order=_n_; run;


proc freq data=&dataname;
tables &ROWVARIABLE*&colvariable/chisq;
ods output ChiSq=ChiSq;
run;

data chisq_p;
set chisq;
if Statistic="Chi-Square";
p_chisq=prob;
order=1;
keep order p_chisq;
run;
 
proc summary data=Freq2 min print;
var Frequency;
ods output Summary=summary;
run; 

data S&id;
length Variable $60 Level $60;
merge freqtable chisq_p;
by order;
method="Chisq";pvalue=p_chisq;
Level=&ROWVARIABLE;
Variable="&ROWVARIABLE"||", n(%)";
if _n_=1 then do; Variable="&ROWVARIABLE"||", n(%)"; end;
if _n_>1 then Variable="";  
/*if _n_ ne 1 then do; Variable="     "||level; pvalue=.; end; */
keep Variable Level  &COLVARIABLE&collevel1 &COLVARIABLE&collevel2 pvalue;
run;

data empty;
order=0; variable="&ROWVARIABLE"||", n(%)";
run;

data S&id; set empty S&id; run;
proc print data=S&id;
run;
%mend;

%macro twoway_digital2(dataname,colvariable,collevel1,collevel2,rowvariable,id);
proc datasets;
delete freq0 freq1 freq2 
col0 col1 col2 
freqtable ChiSq FishersExact chisq_p fisher_p min_cellcount;
run;
proc freq data=&dataname;
tables &ROWVARIABLE; 
ods output OneWayFreqs=freq1;
run;  
proc freq data=&dataname; 
tables  &ROWVARIABLE*&COLVARIABLE;
ods output crosstabfreqs=freq2 ;
run; 
 
proc sort data=freq2 ;
by &ROWVARIABLE;
run; 
    
data col1;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel1 and &ROWVARIABLE~=.;
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel1=frequency||" ("||trim(left(put(RowPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel1="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel1;
run;

data col2;
set freq2;
by &ROWVARIABLE;
where &COLVARIABLE=&collevel2 and &ROWVARIABLE~=.;
if &ROWVARIABLE ne "" then &COLVARIABLE&collevel2=frequency||" ("||trim(left(put(RowPercent,8.1)))||"%"||")";
else &COLVARIABLE&collevel2="N="||trim(left(put(frequency,8.0)));
keep &ROWVARIABLE &COLVARIABLE &COLVARIABLE&collevel2;
run;
 
data col0;  
set freq1; Total=frequency||" ("||trim(left(put(Percent,8.1)))||"%"||")"; 
keep &ROWVARIABLE Total; 
run;

proc sort data=col0; by &ROWVARIABLE; run;
proc sort data=col1; by &ROWVARIABLE; run;
proc sort data=col2; by &ROWVARIABLE; run; 

data freqtable; 
merge col0 col1  col2;  
by &ROWVARIABLE; 
run; 
data freqtable; set freqtable; order=_n_; run;


proc freq data=&dataname;
tables &ROWVARIABLE*&colvariable/chisq;
ods output ChiSq=ChiSq;
run;

data chisq_p;
set chisq;
if Statistic="Chi-Square";
p_chisq=prob;
order=1;
keep order p_chisq;
run;
 

proc summary data=Freq2 min print;
var Frequency;
ods output Summary=summary;
run; 

data S&id;
length Variable $60 Level $60;
merge freqtable chisq_p   ;
by order;
method="Chisq";pvalue=p_chisq; 
Level=&ROWVARIABLE;
Variable="&ROWVARIABLE"||", n(%)";
if _n_ ne 1 then do; Variable="     "||level; pvalue="  "; end; 
keep Variable Level Total &COLVARIABLE&collevel1 &COLVARIABLE&collevel2 pvalue;
run;


data empty;
order=0; variable="&ROWVARIABLE"||", n(%)";
run;

data S&id; set empty S&id; run;

proc print data=S&id;
run;
%mend;

