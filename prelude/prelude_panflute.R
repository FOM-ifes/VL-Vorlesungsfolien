# ===========================================================================
# prelude_panflute.R (Release 1.1)
# ==================---------------------------------------------------------
# (W) by Norman Markgraf in 2019
#
# 15. Jan. 2019  (nm)  Erstes Schritte.
#                      (Release 0.1)
# 16. Jan. 2019  (nm)  Refaktoring!
#                      (Release 0.2)
# 22. Jan. 2019  (nm)  Refaktoring!
#                      (Release 1.0)
# 03. Feb. 2019  (nm)  Nicht dauerhafte prelude funktionen automatisch
#                      löschen mit "prelude.cleanMemory" eingebaut.
#                      (Release 1.1)
#
#   (C)opyleft Norman Markgraf in 2019
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

if (!exists("prelude.panflute")) {
    prelude.panflute <<- "LOADED!"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    # Prüft auf *nix Systemen ob die pandoc Filter im Verzeichnis `pandoc-filter`
    # alles ausführbare Dateien sind und versucht ggf. die Rechte anzupassen.
    #
    checkPandocFilerRights <- function() {
        prelude.panflute.f <- ""
        
        if (.Platform$OS.type == "unix") {
            prelude.panflute.f <- list.files("pandoc-filter",
                                             pattern = ".py$",
                                             all.files = FALSE,
                                             include.dirs = FALSE,
                                             full.name = TRUE, 
                                             recursive = FALSE)
            mode_uga_exec = "111"  # execution für user, group und all
            # Aktueller Mode der Datei lesen
            prelude.panflute.tmp <- file.info(prelude.panflute.f)$mode
            if (prelude.panflute.tmp != (prelude.panflute.tmp | mode_uga_exec)){
                # Falls der aktuelle Mode keine "execution" Rechte vorsieht,
                # dann "excution" Recht hinzufügen!
                Sys.chmod(prelude.panflute.f, prelude.panflute.tmp | mode_uga_exec)
            }
        }
    }

    checkPandocFilerRights()
    
    # Aufräumen:
    if (prelude.cleanMemory) {
        rm(checkPandocFilerRights)
        rm(prelude.panflute)
    }
    
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

# ===========================================================================