
# Machine learning for big data
# Yiou Li Mar. 2012

rm(list=ls())

library(Matrix)

# setwd("C:\\Users\\Leo\\Dropbox\\coding\\VMShare\\recommendMovieLens");

testRatio = 0.1;

dat = read.table("ml-100k/u.data", header=FALSE);
nT = nrow(dat);

idxTest = sample(nT,testRatio*nT);
idxTrain = setdiff((1:nT), idxTest);

nTest = length(idxTest);

# "Remove" the testing samples (ie. set to zero) in the training set
datTrain = dat;
# initialize the rating of the test samples to be the mean rating in traning sample
datTrain[idxTest,3] = mean(datTrain[idxTrain,3]);  

nTrain = length(idxTrain);

# Form the "Big rating matrix" including all users and movies but with only training samples
Y = sparseMatrix(datTrain[,1],datTrain[,2], ,datTrain[,3]);

# Form the "Big rating matrix" including all the training and testing samples
YOrg = sparseMatrix(dat[,1],dat[,2], , dat[,3]);

y.svd = svd(Y);


dimSVDAll = seq(10,min(dim(Y)),by=100);

dimSVDAll = c(10,20)

m = length(dimSVDAll);

sseTrain = rep(0,m);
sseTest = rep(0,m);


for (k in 1:m){
	
	dimSVD = dimSVDAll[k];

	# Construct the estimate rating matrix with number of singular values = dimSVD 
	YHat = y.svd$u[,1:dimSVD]%*%diag(y.svd$d[1:dimSVD])%*%t(y.svd$v[,1:dimSVD]);

	sse = 0
	for(i in 1:nTrain){	
		ix = dat[idxTrain[i],1];
		iy = dat[idxTrain[i],2];
		sse = sse + (YOrg[ix,iy]-YHat[ix,iy])^2;
	}
	sseTrain[k] = sse/nTrain;

	sse = 0
	for(i in 1:nTest){
		ix = dat[idxTest[i],1];
		iy = dat[idxTest[i],2];
		sse = sse + (YOrg[ix,iy]-YHat[ix,iy])^2;
	}
	sseTest[k] = sse/nTest;
	
	print(k);

}
	
plot((1:10),sseTrain,type="l",col="red")
lines((1:10),sseTest,col="green")

