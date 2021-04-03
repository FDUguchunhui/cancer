libname B "Z:\8 GQ Zhang group";
%include "Z:\8 GQ Zhang group\STEP1 data analysis\Macro Freq no p value.sas";

PROC IMPORT OUT= WORK.after_match
            DATAFILE= "Z:\8 GQ Zhang group\STEP1 data analysis\matched_cancer.csv" 
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


proc sort data=matched; by cancer; run;
ods table binomial = CI_Values;
proc freq data=matched;
by cancer;
table death/binomial(level='1');
run;

ods table binomial = CI_Values;
proc freq data=matched;
by cancer;
table severity/binomial(level='1');
run;

proc datasets; delete S1-S7; run;

%twoway_digital_Outcome(matched,cancer, 0,1,death,1 );
%twoway_digital_Outcome(matched,cancer, 0,1,Inpatient,2 );
%twoway_digital_Outcome(matched,cancer, 0,1,ICU,3);
%twoway_digital_Outcome(matched,cancer, 0,1,Ventilation,4);
%twoway_digital_Outcome(matched,cancer, 0,1,severity,5);
%twoway_digital_Outcome(matched,cancer, 0,1,severity_level,7);
 
data Table_outcome_matched;
set S1-S5;
if level=0 or level="N" then delete;
id=_n_;
run;

ods rtf file="Z:\8 GQ Zhang group\STEP1 data analysis\OUTPUT\Table6_outcome_in_matched.rtf" startpage=never;
proc print data=Table_outcome_matched noobs;
var variable level cancer0 cancer1 ;
run;
proc print data=S7;
var variable level cancer0 cancer1 ;
run;
ods rtf close;



proc phreg data=matched;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)  
/ param=ref;
model T_30*death(0)=cancer age_gp gender  
race_gp
Surgery_4w
N_comorbity
N_Posi_Comorb ;
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
Surgery_4w
N_comorbity
N_Posi_Comorb 
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


ods rtf file="Z:\8 GQ Zhang group\STEP1 data analysis\OUTPUT\Table6.rtf" startpage=never;
proc print data=model_Match noobs;
var Variable effect HR pvalue_Cox OR pvalue_logit; 
run;
ods rtf close;
 
