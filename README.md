


# Human Activity Recognition - Classification & ML Project

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, our goal is to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways.  

**Project Objective**:to model "classe" variable.
More information is available from the website here: http://groupware.les.inf.puc-rio.br/har 
(see the section on the Weight Lifting Exercise Dataset).

Data used is similar to The Human Activity Recognition database that was built from the recordings of 30 study participants performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. The objective is to classify activities into one of the six activities performed.

I have used classification & ML techniques like Random Forests, Stochastic Gradient Boosting, PCA etc.
Model with the highest accuracy level (based on training data) was used for predicting "classe" categories for the test data.
**Expected test "classe" categories**: B A B A A E D B A A B C B A E E A B B B . 
(predicted by RF model with 3-fold CV, and an accuracy of 0.9937)

**Full code**: _HAR_classe.R_ file in this repo.  
**Executive summary**: http://rpubs.com/ZackM/HAR-pred


Thank you for your time.

Best,  
Zack

p.s. Over and above the modeling experience, I have started using devices with accelerometers & GPS more often!
