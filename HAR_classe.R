####### Course Project #######

### Get libs & Data ###
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(caret))
suppressMessages(library(nnet))
suppressMessages(library(kernlab))
suppressMessages(library(knitr))
suppressMessages(library(kableExtra))

# The training data for this project are available here:
trainurl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"

# The test data are available here:
testurl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

## Reading & reshaping
mydata <- read.csv(trainurl, na.strings = c(""," ", "NA"))
dim(mydata)
# [1] 19622   160

names(which(colSums(is.na(mydata))>2000))
# na > 0 = 67; # na > 10 = 67;  # na > 10000 =67

# Remove all columns with NAs > 10
mydata2 <- mydata[, -which(colSums(is.na(mydata))>100)]
dim(mydata2)
# [1] 19622    60

### Comparing the performance of various modelling methods (prima facie) ###
# Evaluate best possible method 
# (quick eval without much specifications)
suppressMessages(library(doMC))
registerDoMC(2)
trn_smpl <- sample_n(mydata3, 1500)


#m1 - Bagged CART
set.seed(1234)
mod_cart <- train(classe~.,data=trn_smpl, method="treebag")


#m2 - K-Nearest Neighbors
set.seed(1234)
mod_knn <- train(classe~.,data=trn_smpl, method="knn") 


#m3 - Naive Bayes
set.seed(1234)
mod_nb <- train(classe~.,data=trn_smpl, method="nb")  
 

#m4 - Random Forrest
set.seed(1234)
mod_rf <- train(classe~., data=trn_smpl, method="rf")


#m5 - Stochastic Gradient Boosting
set.seed(1234) 
mod_gbm <- train(classe~.,data=trn_smpl, method="gbm")

#m6 - SVM
set.seed(1234)
mod_svm <- train(classe~., data=trn_smpl, method="svmRadial")

### Visualizing Prediction Accuracy By Method ###

model_comparison <- resamples(list(CART=mod_cart, KNN=mod_knn, NaiveBayes=mod_nb,   RandomForest=mod_rf, GBM=mod_gbm, SVM=mod_svm))

dotplot(model_comparison)

# Highest prediction accuracy achieved with the RF model 

### Preparing data for training & validation of RF model ###
inTrain <- createDataPartition(mydata3$classe, p=0.7, list = F)
training <- mydata3[inTrain, ]
validating <- mydata3[-inTrain, ]

# Some more data exploration
kable(which(complete.cases(mydata3)=="FALSE"))

# To check distribution of classes by level
kable(count(training,classe), "html", align = 'c') %>% kable_styling(full_width=F)

### Model Validation (on part of training set) ###

# Using both cores for efficient proc
registerDoMC(2)

# Setting up train control params for cross validation
set.seed(1234)
trCtrl <- trainControl(method = "cv", number = 3, selectionFunction = "best")

# Training RF without preprocessing (mod1)
mod1 <- train(classe ~., data=training, method="rf", trainControl=trCtrl)
# Predicting classe for validation data (mod1)
pred1 <- predict(mod1, newdata = validating)
# Calc model accuracy (mod1)
acc_mod1 <- confusionMatrix(pred1, validating$classe)$overall[1]

# Training RF with preprocessing (mod2)
mod2 <- train(classe ~., data=training, preProcess="pca", method="rf", trainControl=trCtrl)
# Predicting classe for validation data (mod2)
pred2 <- predict(mod2, newdata = validating)
# Calc model accuracy (mod2)
acc_mod2 <- confusionMatrix(pred2,validating$classe)$overall[1]

# Table for comparing model accuracies
acc_mod1 <- round(acc_mod1, 2)
acc_mod2 <- round(acc_mod2, 2)
accuracy_table <- c("RF-base", (acc_mod1*100),"RF-with-preproc", (acc_mod2*100))
accuracy_table
# Mod1 (RF without preproc) seems to perform the best with ~ 99% accuracy (vs. 97.6% for with preproc)

### Scoring test data, Classe values for test data with RF ###
# Readying test data
testdata <- read.csv(testurl, na.strings = c(""," ", "NA"))
#>> dim(testdata) = [1] 20 160
testdat <- testdata[,-which(colSums(is.na(testdata))>5)]
#>> dim(testdata) = [1] 20 60

# Removing cols with little information value
testdat <- testdat[,8:60]

# Predicting "classe" with Mod1
predTestClasse <- predict(mod1, testdat)
predTestClasse

# B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B

### **** END OF CODE *** ###