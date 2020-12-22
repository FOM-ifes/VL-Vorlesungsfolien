# Run all lines in this file to install needed, but missing packages for day 2 of the statistics seminar

day2 <- c("mosaic", "tidyverse", "viridis", "gridExtra", "sjmisc", "pwr", "simr", "lsr", "MBESS", "MASS", "compute.es", "brms", "broom", "ISLR", "lme4", "rstanarm", "arm", "broom", "sjmisc", "countrycode", "rnaturalearth")


# this function will install missing packages:
install_missing_packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
}


# now run the function:
install_missing_packages(day2)
