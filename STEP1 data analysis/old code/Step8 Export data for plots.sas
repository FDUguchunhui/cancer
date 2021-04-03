libname B "Z:\8 GQ Zhang group";
data alltime;
set B.rawdata;
keep cancer T_30 death cancer;
run;
PROC EXPORT DATA= WORK.alltime  
            OUTFILE= "Z:\8 GQ Zhang group\STEP1 data analysis\alltime.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
 
data matched_data;
set matched;
keep cancer T_30  death;
run;
PROC EXPORT DATA= WORK.matched_data  
            OUTFILE= "Z:\8 GQ Zhang group\STEP1 data analysis\matched_data.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
 
