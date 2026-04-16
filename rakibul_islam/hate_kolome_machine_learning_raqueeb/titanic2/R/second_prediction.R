setwd("~datasets/titanic2")

train<- read.csv("~/datasets/titanic2/train.csv")

summary(train$Sex)

table(train$Sex)

prop.table(table(train$Sex,train$Survived),1)

prop.table(table(train$Sex,train$Survived),1)*100

test<-read.csv("~/datasets/titanic2/test.csv")

test$Survived<-0
test$Survived[test$Sex=='female']<-1

Secondprediction<-data.frame(PassengerId=test$PassengerId,Survived=test$Survived)

write.csv(Secondprediction,file="2ndprediction.csv",row.names=FALSE)
