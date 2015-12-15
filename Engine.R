library("recommenderlab")
library(reshape2)
library(ggplot2)
tr<-read.csv("/Dataset/train_v2.csv",header=TRUE)
# Just look at first few lines of this file
# head(tr)
# Remove 'id' column. We do not need it
tr<-tr[,-c(1)]
# Check, if removed
tr[tr$user==1,]
# Using acast to convert above data as follows:
#       m1  m2   m3   m4
# u1    3   4    2    5
# u2    1   6    5
# u3    4   4    2    5
g<-acast(tr, user ~ movie)
# Check the class of g
class(g)

# Convert it as a matrix
R<-as.matrix(g)
write.csv2(R,file="/Dataset/matrix.csv",sep="^")
# Convert R into realRatingMatrix data structure
#   realRatingMatrix is a recommenderlab sparse-matrix like data-structure
r <- as(R, "realRatingMatrix")
# r
as(r, "list")     # A list
as(r, "matrix")   # A sparse matrix

# I can turn it into data-frame
head(as(r, "data.frame"))

# normalize the rating matrix
r_m <- normalize(r)
# r_m
# as(r_m, "list")

# Create a recommender object (model)
#   Run anyone of the following four code lines.
#     Do not run all four
#       They pertain to four different algorithms.
#        UBCF: User-based collaborative filtering
#        IBCF: Item-based collaborative filtering
#      Parameter 'method' decides similarity measure
#        Cosine or Jaccard
rec=Recommender(r[1:nrow(r)],method="UBCF", param=list(normalize = "Z-score",method="Cosine",nn=5, minRating=1))
print(rec)
names(getModel(rec))
reco=getModel(rec)$nn
# write.csv2(reco,file="/Users/AdityaShibrady/Dropbox/Repository/Education/UT Dallas/Sem 3/Big Data/Big Data Project/Recommendation System/Dataset/reco.csv",sep="^")


#build recommendation system for first 5 rows only
#otherwise it was taking a lot of time.. you might change r[1,5] to r[1:nrow(r)] to run for all rows
recom <- predict(rec, r[1,5], type="ratings")
# recom

# This is my attempt at wiriting it to a file:
Rec <-as(recom, "matrix")
write.csv(Rec,file="/Dataset/reco.csv",sep="^")

#predicting for one user.. user 3 and col no. 7
as(recom, "matrix")[3,7] 
