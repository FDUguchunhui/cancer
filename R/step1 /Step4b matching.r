#match on cancer
mydata <- read.csv ("data/Before_matching.csv") 
 
library(MatchIt)
m.out <-  matchit(Cancer~ GENDER+ REGION+age +           
race_gp + N_comorbity +
N_Posi_Comorb,data = mydata, method = "nearest",ratio =1) 
summary(m.out)  
m.data1 <- match.data(m.out)
write.csv(m.data1, file ="data/matched_cancer_geq_18.csv")
   
  