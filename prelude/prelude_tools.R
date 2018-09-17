# ===========================================================================
# prelude_tools.R (Release 0.1.1)
# ===============------------------------------------------------------------
# (W) by Norman Markgraf, Karsten Lübke & Sebastian Sauer in 2017/18
#
# 23. Feb. 2018  (nm)  Erstes Schritte. Extraktion aus der prelude.R
#                      (0.1.0)
# 18. Mär. 2018  (nm)  Dokumentation angepasst.
#                      (0.1.1)
#
#   (C)opyleft Norman Markgraf, Karsten Lübke & Sebastian Sauer in 2017/18
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Einige Einstellungen für die Skripte in R u.a. die Lübke'sche Kapitel-
# und Übungsverwaltung sind hierhin ausgelagert.
#
# "Es gibt zwei Arten von Programmen:
#  Die einen sind so kurz, dass sie offensichtlich keine Fehler haben.
#  Die anderen sind so lang, dass sie keine offensichtlichen Fehler haben"
#
#                                                     -- Unbekannter Autor
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

library(futile.logger)

if (!exists("prelude.tools")) {
  prelude.tools <<- "LOADED!"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  locDoCSD <- function(path) {
    if (!dir.exists(path)) dir.create(path)
  }


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  transUmlaute <- function(str) {
    return(stringr::str_replace_all(
      str, c(
        "ü" = "ue", "ä" = "ae", "ö" = "oe",
        "Ü" = "Ue", "Ä" = "Ae", "Ö" = "Oe",
        "ß" = "ss"
      )
    ))
  }


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  doCopyAndLog <- function(from, to, overwrite=TRUE) {
    flog.debug(paste("Copy '", from, "' to '", to, "'"))
    file.copy(from, to, overwrite = overwrite)
  }


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  getRelPathToBase <- function() {
      if (file.exists("prelude.R")) {
          return(".")
      } else {
          if (file.exists(file.path("..","prelude.R"))) {
              return("..")
          } else {
              if (file.exists(file.path("..", "..", "prelude.R"))) {
                  return(file.path("..", ".."))
              } else {
                  if (file.exists(file.path("..", "..", "..", "prelude.R"))) {
                      return(file.path("..", "..", ".."))
                  } else {
                      msg <- "FATAL ERROR: Could not finde 'prelude.R' and proper basedirectory!"
                      if (exists(flog.error())) {
                        flog.error(msg)}
                      else {
                          stop(msg)
                      }
                  }
              }
          }
      }
  }
 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  tyxtable <- function(xtab, trim = 2) {
      tmp <- textConnection(capture.output(xtab, file = NULL))
      tmp <- readLines(tmp)
      for (i in seq(along.with = tmp)) {
          tmp[i] <- paste0(tmp[i], "\n")
      }
      if (trim > 0) {
          tmp <- tmp[-1:(-1 * trim)]
      }
      return(tmp)
  }
  
  
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  searchFileInPath <- function(filename, path=c(".", ".."), stopOnFail=TRUE) {
      for(pth in path) {
          fn <- file.path(pth,filename)
          flog.debug(paste0("Probing `", fn, "`!"))
          if (file.exists(fn)) {
              return(fn)
          }
      }
      if (stopOnFail) {
          stop(paste0("FATAL ERROR: ",
                  "Could not find `",filename, "` in search path!"))
      } else {
          return(NULL)
      }
  }
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  loadSomething <- function(filename, path, stopOnFail=TRUE) {
      pfn <- searchFileInPath(filename, path=path, stopOnFail)
      if (!is.null(pfn)) {
          flog.debug(paste0("Loading `",pfn,"`!"))
          source(pfn)  
      } else {
          warning("SHIT!!!")
          flog.debug(paste0("Not loading `", pfn, "`!!!"))
      }
  }
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  loadPrelude <- function(preludeFilename, stopOnFail=TRUE) {
    loadSomething(preludeFilename, path=c(".", "prelude", file.path("..","prelude")), stopOnFail)
  }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  loadPrivate <- function(privateFilename, stopOnFail=TRUE) {
      loadSomething(privateFilename, path=c("private", file.path("..", "private")), stopOnFail)
  }
}

# ===========================================================================