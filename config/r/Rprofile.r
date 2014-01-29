# $R_PROFILE_USER
# $XDG_HOME_CONFIG/r/Rprofile.r                                           
# Last modified: 2014-01-27

# http://gettinggeneticsdone.blogspot.com.es/2013/07/customize-rprofile.html    
# http://stackoverflow.com/questions/1189759/expert-r-users-whats-in-your-rprofile                


# welcome message
 cat("Welcome back gabx!\n")

# customize prompt
options(prompt=paste(paste (Sys.info () [c ("user", "nodename")], collapse="@"),"[R] "))


# User options 
## > options() : list options||style: name=value## 
options(
	digits=4, 
	show.signif.stars=FALSE, 
	stringsAsFactors=FALSE, 
	error = quote(dump.frames("${R_HOME_USER}/testdump", TRUE)),
	repos=c("http://cran.cnr.Berkeley.edu","http://cran.stat.ucla.edu","http://cran.rstudio.com/"),
	browserNLdisabled = TRUE,
	deparse.max.lines = 2
)


## user functions ##
#Create a new invisible environment for all the user functions to go in so it doesn't clutter your workspace.
.env <- new.env()

# retrive user info
.env$ThisUser <- paste (Sys.info () [c ("user", "nodename")], collapse=".")


# set working directory according to user and hostname
setwd (switch (.env$ThisUser, 
           gabx.hortensia  = "/developement/language/r/wd",
           ))


   
#Strip row names from a data frame 
.env$unrowname <- function(x) {
rownames(x) <- NULL
x
}

# automatically load devtools in interactive sessions
if (interactive()) {
  suppressMessages(require(devtools))
}

# List objects and classes 
.env$lsa <- function() {
obj_type <- function(x) { class(get(x)) }
foo=data.frame(sapply(ls(envir=.GlobalEnv),obj_type))
foo$object_name=rownames(foo)
names(foo)[1]="class"
names(foo)[2]="object"
return(unrowname(foo))
}

# Attach all the variables above
attach(.env)


 .Last <- function(){

	if(interactive()) try(savehistory("/developement/language/r/R.Rhistory"))
	file.append("/developement/language/r/R.Rhistory_old","/developement/language/r/R.Rhistory")
	file.rename("/developement/language/r/R.Rhistory_old","/developement/language/r/R.Rhistory")
	cat("\nGoodbye Gabx ", date(), "\n")
}


 .First <- function() {	
cat("\nSuccessfully loaded .Rprofile at", date(), "\n")
}






           
	
		 

