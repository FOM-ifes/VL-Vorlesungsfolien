# ===========================================================================
# prelude_images.R (Release 0.1.0)
# ================-----------------------------------------------------------
# (W) by Norman Markgraf in 2018
#
# 22. Jun. 2018  (nm)  Erstes Schritte
#                      (0.1.0)
#
#   (C)opyleft Norman Markgraf in 2018
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
    extern_image_include <- function(url, filename, localpath) {
      localfilename = file.path(localpath, filename)
      localfilenamecur = file.path("..", localfilename)
      if (!file.exists(localfilenamecur)) {
          flog.debug(paste0("Downloade Datei '", filename, "' von ", url, " nach ", localfilenamecur))
          download.file(url, localfilenamecur, mode = "wb")
      }
      knitr::include_graphics(localfilename)
  }
}

# ===========================================================================