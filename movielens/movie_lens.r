library(Matrix)

m.raw = scan(file="u1.base", what=list(user=0,movie=0,rating=0), flush=TRUE)

m.matrix = sparseMatrix(m.raw$user,m.raw$movie,x=m.raw$rating, dims=c(943,1682))

m.svd = svd(m.matrix)
summary (m.svd)

plot(1:length(m.svd$d), m.svd$d)
plot(1:20, m.svd$d[1:20])

dim(diag(m.svd$d))
[1] 943 943

d <- m.svd$d
u <- m.svd$u
v <- m.svd$v


# Now we use all the values  in our diagonal matrix to reconstruct the original matrix.

m.reconstruction <- u %*% diag(d) %*% t(v)

sum( (m.matrix - m.reconstruction)^2 )
[1] 4.907716e-23



# Now trying to remove the insignificant values


iterations = c(2, 10, 50, 100, 200, 300, 500, 800, 900, 943)
iterations.error = c()

for (i in iterations)
 {
 	print (i)
 	m.compressed <- u[,1:i] %*% diag(d[1:i]) %*% t(v[,1:i])
 	iterations.error  = c( iterations.error, sum( (m.matrix - m.compressed)^2 ) )
}

plot(iterations, iterations.error)


# Now lets use irlba library

library(irlba)
help(irlba)

m.svd2 = irlba(m.matrix, nu = 200, nv = 200)

d2 <- m.svd2$d
u2 <- m.svd2$u
v2 <- m.svd2$v

m.reconstruction2 <- u2 %*% diag(d2) %*% t(v2)

sum( (m.matrix - m.reconstruction2)^2 )
[1] 185321.6


# Now trying to remove the insignificant values


iterations2 = c(2, 10, 20, 30, 40,  50, 100, 150, 200)
iterations2.error = c()

for (i in iterations2)
 {
 	print (i)
 	m.compressed <- u2[,1:i] %*% diag(d2[1:i]) %*% t(v2[,1:i])
 	iterations2.error  = c( iterations2.error, sum( (m.matrix - m.compressed)^2 ) )
}

plot(iterations2, iterations2.error)







# Test Data:

t.raw = scan(file="u1.test", what=list(user=0, movie=0, rating=0), flush=TRUE)
t.matrix = sparseMatrix(t.raw$user,t.raw$movie,x=t.raw$rating, dims=c(943,1682))

t.predict <- u2[,1:i] %*% diag(d2[1:i]) %*% t(v2[,1:i])



# leo

l.raw = scan(file="u1.base", what=list(user=0, movie=0, rating=0), flush=TRUE)l.matrix = sparseMatrix(l.raw$movie, l.raw$user,x=l.raw$rating)

l.svd = svd(l.matrix)

s1 <- l.svd$d
t1 <- l.svd$u
d1 <- l.svd$v


david = l.matrix[405,]
predict = david %*% d1 %*% ginv(diag(s1))
test_predict =  predict %*% diag(s1) %*% t(d1)

par(mfrow=c(1,2))
plot ((1:1682), test_predict, col="red" )
plot ((1:1682), david, col="blue")



# fixed dimentions 

l.raw = scan(file="u1.base", what=list(user=0, movie=0, rating=0), flush=TRUE)
l.matrix = sparseMatrix(l.raw$movie, l.raw$user,x=l.raw$rating)

l.svd = irlba(l.matrix, nu = 200, nv = 200) 

s1 <- l.svd$d
t1 <- l.svd$u
d1 <- l.svd$v

dim(d1)
length(s1)
dim(t1)

david = l.matrix_10[,405]
length(david)

predict = david %*% t1 %*% ginv(diag(s1))
dim(predict)
test_predict =  predict %*% diag(s1) %*% t(t1)
dim(test_predict)

par(mfrow=c(1,2))
plot ((1:1682), test_predict, col="red" )
plot ((1:1682), david, col="blue")


# scale up
t.raw = scan(file="u1.test", what=list(user=0, movie=0, rating=0), flush=TRUE)
t.raw$rating = (t.raw$rating * 100) + 1000
t.matrix = sparseMatrix(t.raw$movie, t.raw$user,x=t.raw$rating, dims=c(1682,943))

l.raw = scan(file="u1.base", what=list(user=0, movie=0, rating=0), flush=TRUE)
l.raw$rating = (l.raw$rating * 100) + 1000

l.matrix = sparseMatrix(l.raw$movie, l.raw$user,x=l.raw$rating, dims=c(1682,943))

l.svd = irlba(l.matrix, nu = 200, nv = 200) 
#l.svd = svd(l.matrix) 

s1 <- l.svd$d
t1 <- l.svd$u
d1 <- l.svd$v

dim(d1)
length(s1)
dim(t1)


plot_numbers = 1

par(mfrow=c(plot_numbers,2))
for (i in c(sample(1:400, plot_numbers)))
{
	david = t.matrix[,i]
	length(david)
	
	david_projection_on_psudo_users = david %*% t1 
	dim(david_projection_on_psudo_users)
	david_rating_predicted =  david_projection_on_psudo_users %*% t(t1)
	dim(david_projection_on_psudo_users)
	
	ylable = paste("rating ", i)
	
	plot ((1:1682), david_rating_predicted, col="red", ylab=ylable, xlab="movies")
	plot ((1:1682), david, col="blue", ylab= ylable, xlab="movies")
}

--------------- 1 M data

t.raw = scan(file="u1.test", what=list(user=0,"", movie=0,"", rating=0), sep=':', flush=TRUE)
t.raw$rating = (t.raw$rating * 100) + 1000
t.matrix = sparseMatrix(t.raw$movie, t.raw$user,x=t.raw$rating, dims=c(3952,6040))

l.raw = scan(file="u1.base", what=list(user=0,"", movie=0,"", rating=0), sep=":", flush=TRUE)
l.raw$rating = (l.raw$rating * 100) + 1000

l.matrix = sparseMatrix(l.raw$movie, l.raw$user,x=l.raw$rating, dims=c(3952,6040))

l.svd = irlba(l.matrix, nu = 200, nv = 200) 
#l.svd = svd(l.matrix) 
#l.svd1m = l.svd





plot_me(2, l.matrix, l.svd, 1500:6040)

-------------------------------------------------------------

plot_me <- function (plot_numbers, data, svd, range ){
	s1 <- svd$d
	t1 <- svd$u
	d1 <- svd$v

#	dim(d1)
#	length(s1)
#	dim(t1)

	par(mfrow=c(plot_numbers,2))
	for (i in c(sample(range, plot_numbers)))
	{
		user = data[,i]
		length(user)
		
		user_projection_on_psudo_users = user %*% t1 
		dim(user_projection_on_psudo_users)
		user_rating_predicted =  user_projection_on_psudo_users %*% t(t1)
		dim(user_rating_predicted)
		
		ylable = paste("rating ", i)
		
		plot ((1:dim (data)[1]), user_rating_predicted, col="red", ylab=ylable, xlab="movies")
		plot ((1:dim (data)[1]), user, col="blue", ylab= ylable, xlab="movies")
	}
}	


