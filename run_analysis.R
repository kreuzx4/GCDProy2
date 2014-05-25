
library(reshape2)

#Test & Train files need to be read 
sTest = read.table("test/subject_test.txt", fill=FALSE, strip.white=TRUE)
xTest = read.table("test/X_test.txt", fill=FALSE,  strip.white=TRUE)
yTest = read.table("test/y_test.txt", fill=FALSE, strip.white=TRUE)
sTrain = read.table("train/subject_train.txt",fill=FALSE,strip.white=TRUE)
xTrain = read.table("train/X_train.txt", fill=FALSE, strip.white=TRUE)
yTrain = read.table("train/y_train.txt",  fill=FALSE,strip.white=TRUE)
features = read.table("features.txt",fill=FALSE, strip.white=TRUE)


#Replace column name with features
names(xTrain) <- features[,2]
names(xTest) <- features[,2]
xTrain<-rbind(xTrain,xTest)

#xVar now has all the data , we remove the previous variables
xvar <- (xTrain)
rm(xTrain)
rm(xTest)
rm(features)

#creating Subject data 
names(sTrain)<-c("Subject")
names(sTest)<-c("Subject")
sTrain<-rbind(sTrain,sTest)

#subs now has all the data , we remove the previous variables
subs <- (sTrain)
rm(sTrain)
rm(sTest)

#creating Activity data 
names(yTrain)<-("Activity")
names(yTest)<-c("Activity")
yTrain<-rbind(yTrain,yTest)

#act now has all the data , we remove the previous variables
act <- (yTrain)
rm(yTrain)
rm(yTest)

#Rename activity labels

act$Act <- "Unset"
act$Act[act$Activity == 1] <- "Walking"
act$Act[act$Activity == 2] <- "Walking_Upstairs"
act$Act[act$Activity== 3] <- "Walking_Downstairs"
act$Act[act$Activity == 4] <- "Sitting"
act$Act[act$Activity == 5] <- "Standing"
act$Act[act$Activity== 6] <- "Laying"


#new data set with all the data included
xvar<-cbind(xvar,subs)
xvar<-cbind(xvar,act)

#xvar now contains all data 

#Create a subset of mean and std 
sMean<- xvar[,grep("mean", colnames(xvar))] 
sStd<- xvar[,grep("std", colnames(xvar))] 
sStd<-cbind(sStd,sMean)
#sStd now contains the means and std, we need to add subject & activities

sStd<-cbind(sStd,act$Act)
sStd<-cbind(sStd,subs)
dataset<-(sStd)
colnames(dataset)[80] <- "Activity"
rm(sStd)

#Create & save a new dataset 
meltDataset<-melt(dataset, id=c("Subject", "Activity"))
finalDS<-dcast(meltDataset, Subject + Activity ~ variable, fun.aggregate=mean)

write.table(finalDS, "finalData.txt", sep="\t")
