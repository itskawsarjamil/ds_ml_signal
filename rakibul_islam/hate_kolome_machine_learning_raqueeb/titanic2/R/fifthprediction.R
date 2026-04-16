library(rpart.plot)
library(rattle)

library(RColorBrewer)



setwd("~/datasets/titanic2")

train <- read.csv("~/datasets/titanic2/train.csv")

test <- read.csv("~/datasets/titanic2/test.csv")

test$Survived <- NA

combined_set <- rbind(train, test)

# factor vs characted mode

combined_set$Name <- as.character(combined_set$Name)

combined_set$Child[combined_set$AGe < 14] <- 'Child'

combined_set$Child[combined_set$Age >= 14] <- 'Adult'

table(combined_set$Child, combined_set$Survived)

combined_set$Child <- factor(combined_set$Child)

combined_set$Mother <- 'Not Mother'

combined_set$Mother[combined_set$Sex == 'female' &
                      combined_set$Parch > 0 &
                      combined_set$Age > 18] <- 'Mother'

table(combined_set$Mother, combined_set$Survived)

combined_set$Mother <- factor(combined_set$Mother)

combined_set$Title <- sapply(
  combined_set$Name,
  FUN = function(x) {
    strsplit(x, split = '[,.]')[[1]][2]
  }
)

combined_set$Title <- sub(' ', '', combined_set$Title)

combined_set$Title[combined_set$Title %in% c('Mme', 'Mlle')] <- 'Mlle'

combined_set$Title[combined_set$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'

combined_set$Title[combined_set$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'

# Convert to a factor
combined_set$Title <- factor(combined_set$Title)

combined_set$Mother <- 'Not Mother'

combined_set$Mother[combined_set$Sex == 'female' &
                      combined_set$Parch > 0 &
                      combined_set$Age > 18 &
                      combined_set$Title != 'Miss'] <- 'Mother'

combined_set$Cabin[1:20]


combined_set$Cabin <- as.character(combined_set$Cabin)

strsplit(combined_set$Cabin[2], NULL)[[1]]

combined_set$Deck <- factor(sapply(combined_set$Cabin, function(x)
  strsplit(x, NULL)[[1]][1]))


combined_set$Fare_type[combined_set$Fare<50]<-"low"

combined_set$Fare_type[combined_set$Fare>50 & combined_set$Fare<=100]<-"med1"

combined_set$Fare_type[combined_set$Fare>100 & combined_set$Fare<=150]<-"med2"

combined_set$Fare_type[combined_set$Fare>150 & combined_set$Fare<=500]<-"high"

combined_set$Fare_type[combined_set$Fare>500]<-"vhigh"

aggregate(Survived~Fare_type, data=combined_set,mean)

combined_set$FamilySize <- combined_set$SibSp + combined_set$Parch + 1

combined_set$Surname <- sapply(combined_set$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})

combined_set$FamilyID <- paste(as.character(combined_set$FamilySize), combined_set$Surname, sep="")

combined_set$FamilyID[combined_set$FamilySize <= 2] <- 'Small'

combined_set$FamilySizeGroup[combined_set$FamilySize == 1] <- 'single'

combined_set$FamilySizeGroup[combined_set$FamilySize < 5 & combined_set$FamilySize > 1] <- 'Smaller'

combined_set$FamilySizeGroup[combined_set$FamilySize > 4] <- 'large'

mosaicplot(table(combined_set$FamilySizeGroup, combined_set$Survived), main='Survival affected by Family Size ', shade=TRUE)

table(combined_set$FamilyID)

table(combined_set$FamilySizeGroup)

combined_set$FamilyID <- factor(combined_set$FamilyID)

combined_set$FamilySizeGroup <- factor(combined_set$FamilySizeGroup)

train <- combined_set[1:891,]

test <- combined_set[892:1309,]

fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID,
             data=train, method="class")

fancyRpartPlot(fit)

prediction_5th <- predict(fit, test, type = "class")

submit <- data.frame(PassengerId = test$PassengerId, Survived = prediction_5th)

write.csv(submit, file = "prediction5th.csv", row.names = FALSE)
