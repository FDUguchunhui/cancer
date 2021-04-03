libname B "Z:\8 GQ Zhang group";
data rawdata;
set B.rawdata;
if gender="Unknown" then gender="";
if age_cancer_gp="miss" then age_cancer_gp="";  
if age_gp="z: Unk" then age_gp="";
*combine cytotoxic drug;
if cytotoxic4wk in ("a. cytotoxic","b. no cytotoxi") then chemo_4w=1;
else if cytotoxic4wk="c. no chemo dr" then chemo_4w=0;
run;

proc freq data=rawdata;
tables cytotoxic4wk chemo_4w age_gp;
run;

data rawdata_cancer; set rawdata; where cancer=1; run;
data rawdata_nocancer; set rawdata; where cancer=0; run;
   
***MODEL 1:Cox regression;
proc phreg data=rawdata_cancer;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)  cancer_type(ref=first)
survive_5yr_more(ref=first)
chemo_4w(ref=first)
age_cancer_gp(ref=first)
Radiation_4w(ref=first)/ param=ref;
model T_30*death(0)=age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb
Surgery_4w
cancer_type
chemo_4w
Radiation_4w
age_cancer_gp
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
 
ods rtf file="Z:\8 GQ Zhang group\STEP1 data analysis\OUTPUT\Table4a-Cox_model.rtf" startpage=never;
proc print data=HRP noobs;
var Parameter level  HR_noca HR_cancer;
run;
ods rtf close;
 


***MODEL 2:logistic regression, severity, cancer;
proc logistic data=rawdata_cancer descending;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)  cancer_type(ref=first)
survive_5yr_more(ref=first)
Radiation_4w(ref=first) chemo_4w(ref=first)
age_cancer_gp(ref=first) / param=ref;
model severity=age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb
Surgery_4w
cancer_type
chemo_4w
Radiation_4w
age_cancer_gp
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

data ORP;
merge ORP_cancer ORP_nocancer;
by id;
run;

 
ods rtf file="Z:\8 GQ Zhang group\STEP1 data analysis\OUTPUT\Table4a_logistic.rtf" startpage=never;
proc print data=ORP noobs;
var variable Effect OR_nocancer OR_cancer ;
run;
ods rtf close;
 
***MODEL 3: Multinomial model;
*severity, cancer;
proc logistic data=rawdata_cancer descending;
class  age_gp(ref=first) gender(ref=first)    race_gp(ref="Non-hispanic white")
Surgery_4w(ref=first)  cancer_type(ref=first)
survive_5yr_more(ref=first)
chemo_4w(ref=first)
Radiation_4w(ref=first)
age_cancer_gp(ref=first)/ param=ref;
model  severity_level=age_gp gender  
race_gp
N_comorbity
N_Posi_Comorb
Surgery_4w
cancer_type
chemo_4w
Radiation_4w
age_cancer_gp
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

 
 
ods rtf file="Z:\8 GQ Zhang group\STEP1 data analysis\OUTPUT\Table 5-MNP.rtf" startpage=never;
proc print data=MNP noobs;
var Variable effect
MN_nocancer1 MN_nocancer2 MN_nocancer3 
MN_cancer1 MN_cancer2 MN_cancer3  
 ;
run;
ods rtf close;
 
 
