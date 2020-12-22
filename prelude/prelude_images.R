# ===========================================================================
# prelude_images.R (Release 0.3.0)
# ================-----------------------------------------------------------
# (W) by Norman Markgraf in 2018-20
#
# 22. Jun. 2018  (nm)  Erstes Schritte
#                      (0.1.0)
# 04. Apr. 2019  (nm)  Erstes Schritte
#                      (0.2.0)
# 07. Feb. 2020  (nm)  Knitr 1.28 braucht ein ", error=FALSE)" 
#                      (0.2.1)
# 07. Feb. 2020  (nm)  Knitr 1.28 braucht ein ", error=FALSE)" 
#                      Also überschreiben wir es! ;-)
#                      (0.2.2)
# 31. Aug. 2020  (nm)  Nur convertieren wenn nötig! 
#                      (0.3.0)
#
#   (C)opyleft Norman Markgraf in 2018-20
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
# "Es gibt zwei Arten von Programmen:
#  Die einen sind so kurz, dass sie offensichtlich keine Fehler haben.
#  Die anderen sind so lang, dass sie keine offensichtlichen Fehler haben"
#
#                                                     -- Unbekannter Autor
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

library(futile.logger)

if (!exists("prelude.images")) {
  prelude.images <<- "LOADED!"
  
  
# ---------------------------------------------------------------------------
# FIX für knitr 1.28+:

include_graphics = function(...) {
    knitr::include_graphics(..., error = FALSE)
}
  
# ---------------------------------------------------------------------------
    extern_image_include <- function(url, filename, localpath, subsub=FALSE, convertToPDF=TRUE) {
      auto_pdf <- FALSE
      localfilename = file.path(localpath, filename)
      localfilenamecur = file.path("..", localfilename)
      if (subsub) {
          localfilenamecur = file.path("..", localfilenamecur)
      }
      if (!file.exists(localfilenamecur)) {
          flog.debug(paste0("Lade die Datei '", 
                            filename, 
                            "' von ", 
                            url, 
                            " nach ", 
                            localfilenamecur,
                            "herunter."))
          download.file(url, localfilenamecur, mode = "wb")
      }
      if (convertToPDF && .Platform$OS.type == "unix") {
          library(stringr)
          if (str_detect(filename, ".jpg")){
              oldlocalfilenamecur <- localfilenamecur
              pdflocalfilenamecur <- str_replace(localfilenamecur, ".jpg", ".pdf")
              if (!file.exists(pdflocalfilenamecur)) {
                flog.debug(paste0("Konvertiere die Datei '", 
                                  oldlocalfilenamecur, 
                                  "'",
                                  " nach '", 
                                  pdflocalfilenamecur,
                                  "' !"))
                system(paste("convert", oldlocalfilenamecur, pdflocalfilenamecur))
                #print(paste("convert", oldlocalfilenamecur, pdflocalfilenamecur))
              }
              str_replace(localfilename, ".jpg", ".pdf")
              auto_pdf <- TRUE
          }
      }
      knitr::include_graphics(localfilename, auto_pdf=auto_pdf, error=FALSE)
  }
}

# ===========================================================================