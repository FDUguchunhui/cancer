libname B "Z:\8 GQ Zhang group";

proc freq data=B.rawdata;
tables   GENDER   REGION              
race_gp   cancer Surgery_4w  
 ;
run;
data DATA_FOR_MATCHING;
set B.rawdata;
keep Patient_ID GENDER   REGION age            
race_gp   cancer Surgery_4w   
  N_comorbity 
N_Posi_Comorb  
;
if Patient_ID="" 
or  GENDER="Unknown" or     
REGION="z: Other/Unkn"   
or race_gp="Others/Unknown"  
or  age=.            
or cancer=. or 
Surgery_4w=. or   
N_comorbity=. or N_Posi_Comorb=. then delete;
run;

proc freq data= DATA_FOR_MATCHING;
table gender region race_gp Surgery_4w;
run;

proc means data=DATA_FOR_MATCHING nmiss;
var age N_comorbity N_Posi_Comorb;
run;

PROC EXPORT DATA= WORK.DATA_FOR_MATCHING 
            OUTFILE= "Z:\8 GQ Zhang group\STEP0 prepare data\Before_matching.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN; 
