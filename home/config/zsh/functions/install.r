#!/usr/bin/env r --vanilla

# This function needs littler to be installed
# It will install given packages as argument: install.r Package1 Package2

if (is.null(argv) | length(argv)<1) {
  cat("Usage: installr.r pkg1 [pkg2 pkg3 ...]\n")
  q()
}

repos <- "http://cran.rstudio.com"

lib.loc <- Sys.getenv("R_LIBS_USER")

install.packages(argv, lib.loc, repos)
