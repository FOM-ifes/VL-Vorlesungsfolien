# ===========================================================================
# prelude_python.R (Release 0.2)
# ================-----------------------------------------------------------
# (W) by Norman Markgraf in 2018
#
# 30. Dez. 2018  (nm)  Erstes Schritte.
#                      (Release 0.1)
# 16. Jan. 2018  (nm)  Refaktoring!
#                      (Release 0.2)
#
#   (C)opyleft Norman Markgraf in 2018/19
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
#
# "Es gibt zwei Arten von Programmen:
#  Die einen sind so kurz, dass sie offensichtlich keine Fehler haben.
#  Die anderen sind so lang, dass sie keine offensichtlichen Fehler haben"
#
#                                                     -- Unbekannter Autor
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

library(futile.logger)
library(stringi)

if (!exists("prelude.python")) {
    prelude.python <<- "LOADED!"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    prelude.python.path = ""
    prelude.python.path.new = ""
    prelude.python.con = ""
    prelude.python.python_bin = ""
    
    prelude.python.python_bin.path = file.path("private","python-bin.path")
    
    if (file.exists(prelude.python.python_bin.path)) {
        prelude.python.path <- Sys.getenv("PATH")
        flog.debug(paste0("Current PATH is ", 
                          prelude.python.path, 
                          "."))
        prelude.python.python_bin <- readLines( 
            prelude.python.con <- file(file.path("private","python-bin.path"), 
                                       encoding="UTF-8"), 
            n=1, 
            warn=FALSE)
        if (!stringi::stri_detect_fixed(prelude.python.path, 
                                        prelude.python.python_bin)) {
            prelude.python.path.new <- paste0(prelude.python.path, 
                                              .Platform["path.sep"], 
                                              prelude.python.python_bin)
            flog.info(paste0("Change PATH to ", prelude.python.path.new, "."))
            Sys.setenv("PATH" = prelude.python.path.new)
        }
        close(prelude.python.con)
    } else {
        flog.debug(paste0("Could not find '", 
                          prelude.python.python_bin.path,
                          "'!"))
    }
    
    # Aufräumen!
    rm(prelude.python.con)
    rm(prelude.python.path)
    rm(prelude.python.path.new)
    rm(prelude.python.python_bin)
    rm(prelude.python.python_bin.path)
    
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

# ===========================================================================