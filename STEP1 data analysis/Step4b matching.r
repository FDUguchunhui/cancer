#match on cancer
mydata <- read.csv ("Z:\\8 GQ Zhang group\\Organized Code\\Before_matching.csv") 
attach(mydata) 
 
library(MatchIt)
m.out = matchit(Cancer~ GENDER+ REGION+age +           
race_gp + N_comorbity +
N_Posi_Comorb,data = mydata, method = "nearest",ratio =1) 
summary(m.out)  
m.data1 <- match.data(m.out)
write.csv(m.data1, file ="Z:\\8 GQ Zhang group\\Organized Code\\matched_cancer_geq_18.csv")
   
   