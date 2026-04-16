setwd("~/datasets/titanic2")

train<-read.csv("~/datasets/titanic2/train.csv")

test<-read.csv("~/datasets/titanic2/test.csv")

train$Fare2<-'30+'

train$Fare2[train$Fare<30 & train$Fare>=20]<-'20-30'

train$Fare2[train$Fare<20 & train$Fare>=10]<-'10-20'

train$Fare2[train$Fare<10]<-'<10'

aggregate(Survived~Fare2+Pclass+Sex,data=train,FUN=sum)

aggregate(Survived~Fare2+Pclass+Sex,data=train,FUN=length)

aggregate(Survived~Fare2+Pclass+Sex,data=train,FUN=function(x){sum(x)/length(x)})

test$Survived<-0

test$Survived[test$Sex=='female']<-1

test$Survived[test$Sex=='female' & test$Pclass==3 & test$Fare>=20]<-0

predictionthird<-data.frame(test$PassengerId,test$Survived)

names(predictionthird)<-c("PassengerId","Survived")

rownames(predictionthird)<-NULL

write.csv(predictionthird,file="predictionthird.csv",row.names=FALSE)


View(predictionthird)
