#call libraries
library(dplyr)
library(pROC)
library(caret)
library(caTools)
library(e1071)
library(ROCR)
library(gbm)
library(DMwR)
library(randomForest)

library(shiny)
shinyServer(
  
  
  function(input,output, session){
    
    observeEvent(list(input$sex,input$age,input$province,input$mode),
                 {
                     
                   
                   
                   
                 }
                 
  )
                 
 
    output$value <- renderText({
      covkr <- read.csv("covid_kr.csv")
      head(covkr)
      
      #convert output var to factor
      covkr_fct <- mutate(covkr,death2=factor(death))
      head(covkr_fct)
      
      #drop old output
      covkr_fct = subset(covkr_fct, select = c(-death))
      head(covkr_fct)
      
      #rename death2 to death
      covkr_fct <- covkr_fct %>% rename(death = death2)
      head(covkr_fct)
      
      #split data to train and test samples                     
      set.seed(04162020)
      id<-sample(2,nrow(covkr_fct),prob = c(0.8,0.2),replace = TRUE)
      train<-covkr_fct[id==1,]
      test<-covkr_fct[id==2,]
      
      bal.data <- SMOTE(death ~., train, perc.over = 2000, k = 5, perc.under = 100)
      
      ###################implement GBM#################
      model <- caret::train(death ~ .,
                            data = bal.data,
                            method = "rf",
                            trControl = trainControl(method = "repeatedcv", 
                                                     number = 10, 
                                                     repeats = 3, 
                                                     verboseIter = FALSE),
                            verbose = 0)
     
      
      pred=predict(model,data.frame(sex=as.numeric(as.character(input$sex)),age=as.numeric(as.character(input$age)),province=as.numeric(as.character(input$province)),mode=as.numeric(as.character(input$mode))),type="prob")
    
     
      y= round(pred[2]*100,1)

     
      paste ("Mortality risk:", y,"%",sep="")
      

      
      }
  )
    }
)

