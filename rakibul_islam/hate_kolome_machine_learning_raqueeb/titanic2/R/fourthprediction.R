install.packages('rattle')

install.packages('rpart.plot')

install.packages('RColorBrewer')

library(rpart)

library(rattle)

library(rpart.plot)

library(RColorBrewer)

setwd("~/datasets/titanic2")

train <- read.csv("~/datasets/titanic2/train.csv")

test <- read.csv("~/datasets/titanic2/test.csv")

mytree1 <- rpart(Survived ~ Sex, data = train, method = "class")

fancyRpartPlot(mytree1)

mytree3 <- rpart(
  Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
  data = train,
  method = "class"
)

plot(mytree3)

text(mytree3)

fancyRpartPlot(mytree3)

prediction4th <- predict(mytree3, test, type = "class")

prediction4 <- data.frame(PassengerId = test$PassengerId, Survived = prediction4th)

write.csv(prediction4, file = "fourthpredict.csv", row.names = FALSE)
