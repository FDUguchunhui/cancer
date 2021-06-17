library(survival)
library("survminer")

#before matching;
rawdata=read.csv(file="data/alltime.csv",head=T)
fit <- survfit(Surv(T_30,  death) ~ Cancer,data = rawdata)
  
#after matching;
matched_data=read.csv(file="data/matched_data.csv",head=T)
fit_aftermatch <- survfit(Surv(T_30, death) ~ Cancer,data = matched_data)
ggsurvplot(fit_aftermatch, data = matched_data, ylim = c(0.85,1),conf.int = TRUE)

splots <- list()
splots[[1]] <- ggsurvplot(fit, data = rawdata,xlim=c(0,30), ylim = c(0.9,1),,xlab="Days since COVID diagnosis",conf.int = TRUE,censor=F,font.x = c(11,  "black"),font.y = c(11, "black"),linetype = 1,size = 1,palette = "lancet") 
splots[[2]] <- ggsurvplot(fit_aftermatch , data = matched_data, xlim=c(0,30),ylim = c(0.9,1),xlab="Days since COVID diagnosis",conf.int = TRUE,censor=F,font.x = c(11, "black"),
   font.y = c(11,  "black"),linetype = 1,size = 1,palette = "lancet")
   
arrange_ggsurvplots(splots, print = TRUE,
  ncol = 2, nrow = 1, risk.table.height = 0.4,ggtheme = theme_minimal())
  
 
 ####################################PLOT FOR LUNG CANCER;
 library(survival)
library("survminer")

#before matching;
rawdata=read.csv(file="data/alltime_lung_cancer.csv",head=T)
fit <- survfit(Surv(T_30,  death) ~ Cancer,data = rawdata)
  
#after matching;
matched_data=read.csv(file="data/matched_data_lung_cancer.csv",head=T)
fit_aftermatch <- survfit(Surv(T_30, death) ~ Cancer,data = matched_data)
ggsurvplot(fit_aftermatch, data = matched_data, ylim = c(0.85,1),conf.int = TRUE)

splots <- list()
splots[[1]] <- ggsurvplot(fit, data = rawdata,xlim=c(0,30), ylim = c(0.9,1),,xlab="Days since COVID diagnosis",conf.int = TRUE,censor=F,font.x = c(11,  "black"),font.y = c(11, "black"),linetype = 1,size = 1,palette = "lancet") 
splots[[2]] <- ggsurvplot(fit_aftermatch , data = matched_data, xlim=c(0,30),ylim = c(0.9,1),xlab="Days since COVID diagnosis",conf.int = TRUE,censor=F,font.x = c(11, "black"),
   font.y = c(11,  "black"),linetype = 1,size = 1,palette = "lancet")
   
arrange_ggsurvplots(splots, print = TRUE,
  ncol = 2, nrow = 1, risk.table.height = 0.4,ggtheme = theme_minimal())
  