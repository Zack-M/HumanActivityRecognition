####### Course Project #######
library(dplyr)
library(caret)
library(e1071)

# The training data for this project are available here:
trainurl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"

# The test data are available here:
testurl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"


mydata <- read.csv(trainurl, na.strings = c(""," ", "NA"))
dim(mydata)
# [1] 19622   160

names(which(colSums(is.na(mydata))>2000))
# na > 0 = 67; # na > 10 = 67;  # na > 10000 =67

# Remove all columns with NAs > 10
mydata2 <- mydata[, -which(colSums(is.na(mydata))>100)]
dim(mydata2)
# [1] 19622    60

# Exploring data
head(mydata2[,1:10])
tail(mydata2[,1:10])
# first 7 columns have very limited information value
mydata3 <- mydata2[,8:60]

# Check if subset mydata3 has any more NAs
which(complete.cases(mydata3)=="FALSE")

# partition data for training and validation
inTrain <- createDataPartition(mydata3$classe, p=0.7, list = F)
training <- mydata3[inTrain, ]
validating <- mydata3[-inTrain, ]

summary(training$classe)
# A    B    C    D    E 
# 5580 3797 3422 3216 3607 

# Setting up train control params for cross validation
trCtrl <- trainControl(method = "cv", number = 3, selectionFunction = "best")

set.seed(2345)
# Modeling a Random Forest
mod1 <- train(classe ~., data=training, method="rf", trainControl=trCtrl)
pred1 <- predict(mod1, newdata = validating)
acc_mod1 <- confusionMatrix(pred1, validating$classe)$overall[1]
acc_mod1
# Accuracy 0.9937128 

### PARALLELIZE job using doMC
library(doMC)
registerDoMC(2)

# Modeling a Random Forest with PCA preprocessing
mod2 <- train(classe ~., data=training, preProcess="pca", method="rf", trainControl=trCtrl)
pred2 <- predict(mod2, newdata = validating)
acc_mod2 <- confusionMatrix(pred2,validating$classe)$overall[1]
acc_mod2
# Accuracy 0.9748513 

# Predicting "classe" for test data
testdata <- read.csv(testurl, na.strings = c(""," ", "NA"))
dim(testdata)
# [1] 20 160
testdat <- testdata[,-which(colSums(is.na(testdata))>5)]
dim(testdat)
# [1] 20 60
testdat <- testdat[,8:60]

predClasse1 <- predict(mod1, testdat)
predClasse2 <- predict(mod2, testdat)

preds <- data.frame(pred1, pred2, Classe=validating$classe)
library(ggplot2)
g <- ggplot(preds, aes(pred1,pred2))
g+geom_tile(aes(fill=preds$Classe), color="white")+
  geom_text(aes(label=sprintf("%1.0f", preds$Classe)), vjust=1)+
  scale_fill_gradient(low="red", high = "green")+
  theme_bw()+
  theme(legend.position = "none")