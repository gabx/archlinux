# $R_PROFILE_USER
# $XDG_HOME_CONFIG/r/Rprofile.r @ hortensia                                          
# Last modified: 2014-05-30

# http://gettinggeneticsdone.blogspot.com.es/2013/07/customize-rprofile.html    
# http://stackoverflow.com/questions/1189759/expert-r-users-whats-in-your-rprofile                


# set working directory
setwd("/developement/language/r/wd")

# welcome message
cat("Welcome back", Sys.getenv("USER"),"!\n")
cat("working directory:", getwd(), "\n")

# customize prompt
options(prompt=paste(paste (Sys.info () [c ("user", "nodename")], collapse="@"),"[R] "))

# load packages



# User options 
## > options() : list options||style: name=value## 
options(
	digits = 12,
	show.signif.stars=FALSE, 
	stringsAsFactors=FALSE, 
	error = quote(dump.frames("${R_HOME_USER}/testdump", TRUE)),
	repos=c("http://cran.cnr.Berkeley.edu","http://cran.stat.ucla.edu","http://cran.rstudio.com/"),
	browserNLdisabled = TRUE,
	deparse.max.lines = 2
)

# user functions
# retrive user info
ThisUser <- paste (Sys.info () [c ("user", "nodename")], collapse=".")

# clean global environment
clean <- function(){
	rm(list = ls())
  
# automatically load devtools in interactive sessions
if (interactive()) {
  suppressMessages(require(devtools))
}




 .Last <- function(){

	if(interactive()) try(savehistory("/developement/language/r/R.Rhistory"))
	file.append("/developement/language/r/R.Rhistory_old","/developement/language/r/R.Rhistory")
	file.rename("/developement/language/r/R.Rhistory_old","/developement/language/r/R.Rhistory")
	cat("\nGoodbye Gabx ", date(), "\n")
}


# .First <- function() {	
#cat("\nSuccessfully loaded Rprofile on", date(), "\n")
#}






           
	
		 

