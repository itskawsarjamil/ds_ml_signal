setwd("~datasets/titanic2")

train<- read.csv("~/datasets/titanic2/train.csv")

train

View(train)


test<-read.csv("~/datasets/titanic2/test.csv")

test

View(test)

table(train$Survived)

prop.table(table(train$Survived))

prop.table((table(train$Survived)))*100

barplot(table(train$Survived),xlab="Survived",ylab="People",main="Train Data Survival")

test$Survived<-rep(0,418)

prediction1<-data.frame(PassengerId=test$PassengerId,Survived=test$Survived)

write.csv(prediction1,file="all_dies.csv",row.names=FALSE)

barplot(table(train$Sex),xlab="Passenger",ylab="People",main="Train Data Passenger")
