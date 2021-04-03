#match on cancer
mydata <- read.csv ("Z:\\8 GQ Zhang group\\STEP0 prepare data\\Before_matching.csv") 
attach(mydata)
mydata[1:10,] 
 
library(MatchIt)
m.out = matchit(Cancer~ GENDER+ REGION+age +           
race_gp+Surgery_4w  + N_comorbity +
N_Posi_Comorb,data = mydata, method = "nearest",ratio =1) 
summary(m.out)  
m.data1 <- match.data(m.out)
write.csv(m.data1, file ="Z:\\8 GQ Zhang group\\STEP1 data analysis\\matched_cancer.csv")
   
#below 18;
#match on cancer
mydata <- read.csv ("Z:\\8 GQ Zhang group\\STEP0 prepare data\\Before_matching.csv") 
attach(mydata)
mydata_less_18=mydata[mydata$age<18,] 
 
library(MatchIt)
m.out = matchit(Cancer~ GENDER+ REGION+age +           
race_gp+Surgery_4w  + N_comorbity +
N_Posi_Comorb,data = mydata_less_18, method = "nearest",ratio =1) 
summary(m.out)  
m.data1 <- match.data(m.out)
write.csv(m.data1, file ="Z:\\8 GQ Zhang group\\STEP1 data analysis\\matched_cancer_below_18.csv")
      
#greater or equal to 18;
#match on cancer
mydata <- read.csv ("Z:\\8 GQ Zhang group\\STEP0 prepare data\\Before_matching.csv") 
attach(mydata)
mydata_geq_18=mydata[mydata$age>=18,] 
 
library(MatchIt)
m.out = matchit(Cancer~ GENDER+ REGION+age +           
race_gp+Surgery_4w  + N_comorbity +
N_Posi_Comorb,data = mydata_geq_18, method = "nearest",ratio =1) 
summary(m.out)  
m.data1 <- match.data(m.out)
write.csv(m.data1, file ="Z:\\8 GQ Zhang group\\STEP1 data analysis\\matched_cancer_geq_18.csv")
   