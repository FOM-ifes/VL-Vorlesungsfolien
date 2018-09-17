# 
# Quick-Update of the Pandoc Python filter.
#
# (C) in 2018 by Norman Markgraf (nmarkgraf@hotmail.com)
#


updatePythonFiles <- function(
    master="",  
    tmp="tmp-python", 
    dest="pandoc-filter", 
    repositoryMain="https://github.com/NMarkgraf/", 
    repositorySuffix="/archive/master.zip") {
  url <- paste0(repositoryMain, master, repositorySuffix)
  # erzeuge ein temporeres Verzeichnis
  if (dir.exists(tmp)) {
    unlink(tmp, recursive=TRUE, force=TRUE)
  }
  dir.create(tmp)
  # Erzeuge ggf. das Zielverzeichnis
  if (!dir.exists(dest)) {
    dir.create(dest)
  }
  
  zipfilename <- paste0(master, ".zip")
  # lade ZIP-Datei in das temporäre Verzeichnis
  download.file(url, file.path(tmp, zipfilename))
  
  # Entpacke die ZIP Datei
  unzip(file.path(tmp, zipfilename), exdir=tmp)
  
  # Erzeuge Dateiliste
  files <- file.path(tmp, paste0(master, "-master"), list.files(file.path(tmp,paste0(master, "-master")), ".py$"))
  file.copy(files, dest)
  unlink(tmp, recursive = TRUE, force = TRUE)  
}

updatePythonFiles("style.py")
updatePythonFiles("typography.py")
