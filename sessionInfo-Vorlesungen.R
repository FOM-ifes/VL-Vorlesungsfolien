#title: "SessionInfo für das Repo 'Vorlesungen'"




#library(tinytex)
#library(rmarkdown)
#library(tidyverse)
library(sessioninfo)

sessioninfo_vorlesungen <- function(output_file = "sessioninfo.txt",
                                    write_to_disk = TRUE)  {
  
  # This function gives information about system configuration 
  # that may affect Rmd-output files ("session info").
  # input: 
      # - name of file where session info should be written to
      # - whether or not a file should be written to disk
  # output:
      # - object with sessioninfo details
      # - file written to disk, default name "sessioninfo.txt"
  
  
  
# define output list:  
si <- list()


# get session infos:

# General:
si$date_time <- Sys.time()
si$user_name <- Sys.info()[7]
si$platform <- sessionInfo()$platform
si$locale <- sessionInfo()$locale

# R:
si$R_version <- sessionInfo()$R.version$version.string
si$loadedpackages <- sessioninfo::package_info()
si$installedpackages <- as.data.frame(installed.packages()[,c(1,3:4)]) 
si$installedpackages <- si$installedpackages[is.na(si$installedpackages$Priority),1:2,drop=FALSE]
rownames(si$installedpackages) <- NULL
si$number_installed_packages <- nrow(si$installedpackages)

# TeX:
si$tex_version <- system("tlmgr --version", intern = T)
si$tex_pckgs <- system("tlmgr info --list --only-installed --data name", intern = T)
si$pdflatex_path <- Sys.which('pdflatex')

# Pandoc
si$p3_version <- system("python3 --version", intern = T)
si$panflute_installed <- system("pip3 show panflute", intern = T) 





# write to file:
if (write_to_disk == TRUE) {
  sink(file = output_file)
  print(si)
  sink()
  cat("session info was written to file: ", output_file, "\n")
}


return(si)

}




# Run the function:


si <- sessioninfo_vorlesungen()
si


