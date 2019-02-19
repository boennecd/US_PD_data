# Step 0
Check the `.Rprofile` and make sure that you are able to connect to WRDS.
Knit the documents at the project root. You can change this in Rstudio in the
"Knit" drop down menu. I use [packrat](https://rstudio.github.io/packrat/) to 
ensure that it is easier to reproduce the results. It should start installing the 
packages and exact versions of the packages if you open the `US_data_prep.Rproj` file. 

# Step 1
Do the following in an arbitrary order

 - Run `markdown/dl_from_wrds.Rmd`. It downloads the data from WRDS.
 - Run `markdown/moodys.Rmd` to create the needed data from Moody's Default 
   and Recovery Database.
   
# Step 2
Run `markdown/mapping.Rmd` to create the map between `permno` and Moody's
firm identifier.

# Step 3
Do the following in an arbitrary order

 - Run `markdown/distance-to-default.Rmd` to calculate the distance-to-default.
 - Run `markdown/market-data.Rmd` to calculate other market based variables. 
 
# Step 4
Run `markdown/merging.Rmd` to create the final data set.

# Updating databases 
The Moody's Default & Recovery Database that is used is from October 2016. 
I am not sure how much the database changes from version to version but
if it does change then this may break the code. The `markdown/mapping.Rmd`
file will need to be updated regardless of whether the structure of the 
database do change as it contains some hard-coded matches. 

# Final comments
There are some very elementary comments throughout the code. E.g., what is 
a `permno` and `permco`. The code was written when 
[boennecd](https://github.com/boennecd) had limited experience  the databases
and is left in for now.
