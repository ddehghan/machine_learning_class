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



==============  PREDICTIONS ==================




-------------- 100k data 

t.raw = scan(file="ml-100k/u1.test", what=list(user=0, movie=0, rating=0), flush=TRUE)

t.raw$rating = (t.raw$rating * 100) + 1000

t.matrix = sparseMatrix(t.raw$movie, t.raw$user,x=t.raw$rating, dims=c(1682,943))

l.raw = scan(file="ml-100k/u1.base", what=list(user=0, movie=0, rating=0), flush=TRUE)

l.raw$rating = (l.raw$rating * 100) + 1000

l.matrix = sparseMatrix(l.raw$movie, l.raw$user,x=l.raw$rating, dims=c(1682,943))

#l.svd = irlba(l.matrix, nu = 200, nv = 200) 
l.svd = svd(l.matrix) 


l.svd2 = irlba(l.matrix, nu = 200, nv = 200) 
plot_user(2, t.matrix, l.svd2, 1:400)
plot_movie(2, t.matrix, l.svd2, 1:1682)

--------------- 1 M data

t.raw = scan(file="ml-1m/u1.test", what=list(user=0,"", movie=0,"", rating=0), sep=':', flush=TRUE)
t.raw$rating = (t.raw$rating * 100) + 1000
t.matrix = sparseMatrix(t.raw$movie, t.raw$user,x=t.raw$rating, dims=c(3952,6040))

l.raw = scan(file="ml-1m/u1.base", what=list(user=0,"", movie=0,"", rating=0), sep=":", flush=TRUE)
l.raw$rating = (l.raw$rating * 100) + 1000

l.matrix = sparseMatrix(l.raw$movie, l.raw$user,x=l.raw$rating, dims=c(3952,6040))

l.svd = irlba(l.matrix, nu = 200, nv = 200) 
#l.svd = svd(l.matrix) 
#l.svd1m = l.svd




plot_user (2, l.matrix, l.svd, 1500:6040)

-------------------------------------------------------------

plot_user <- function (plot_numbers, data, svd, range ){
	s1 <- svd$d
	t1 <- svd$u
	d1 <- svd$v

	dim(d1)
	length(s1)
	dim(t1)

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
-------------------------------------------------------------

plot_movie <- function (plot_numbers, data, svd, range ){

	s1 <- svd$d
	t1 <- svd$u
	d1 <- svd$v

	dim(d1)
	length(s1)
	dim(t1)


	par(mfrow=c(plot_numbers,2))
	for (i in c(sample(range, plot_numbers)))
	{
		movie = data[i,]
		length(movie)
		
		movie_projection_on_psudo_movies = movie %*% d1 
		dim(movie_projection_on_psudo_movies)
		movie_rating_predicted =  movie_projection_on_psudo_movies %*% t(d1)
		dim(movie_rating_predicted)
		
		ylable = paste("rating ", i)
		
		plot ((1:dim (data)[2]), movie_rating_predicted, col="red", ylab=ylable, xlab="users")
		plot ((1:dim (data)[2]), movie, col="blue", ylab= ylable, xlab="users")
	}
}	




----------------------- TEST --------------

l.svd = irlba(l.matrix, nu = 200, nv = 200) 


dim(l.matrix) 

dim(l.svd$v)  #t1
length(l.svd$d) #s1
dim(l.svd$u) #d1

length(l.matrix[,4])
dim(l.matrix[,4] %*% l.svd$u)
dim(l.matrix[,4] %*% l.svd$u %*% l.svd$v )

vv = l.svd$v %*% (diag(l.svd$d))^2 %*% t(l.svd$v)
uu = l.svd$u %*% (diag(l.svd$d))^2 %*% t(l.svd$u)

dim(vv)
dim(uu)

t(l.matrix[,942] %*% l.svd$u)

i = 942
l.error = c()

l.predict <- l.svd$u[,1:i] %*% diag(l.svd$d[1:i]) %*% t(l.svd$v[,1:i])

l.error  = c( l.error, sum( (l.matrix - l.predict)^2 ) )
l.error


i = 942
l.error = c()

l.svd$u[1,1:i]

l.predict <- l.svd$u[1,1:i] %*% diag(l.svd$d[1:i]) %*% t(l.svd$v[,1:i])

l.error  = c( l.error, sum( (l.matrix - l.predict)^2 ) )
l.error


