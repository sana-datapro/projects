
## Building a Movies Recommender System
Created a program that recommends the 10 mostly rated movies to the user.

## Tools Used
Python

## Steps performed:

- Loading data (ratings and movie titles datasets)
- Merging the two datasets based on a common column 'movieID'
- Calculating the average rating and the total rating for each movie
- Calculating The Correlation between movie titles and the movie selected based on ratings using the corrwith method
- Merging the Total Ratings to the correlation table.
- filtering all the movies correlated to the selected movie and have total ratings exceeding 100.
- verifying the recommendations (filter only the 10 mostly rated to user)
