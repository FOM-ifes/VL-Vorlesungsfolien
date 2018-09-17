# ===========================================================================
# prelude_rendertools.R (Release 0.1.2)
# =====================------------------------------------------------------
# (W) by Norman Markgraf in 2018
#
# 23. Feb. 2018  (nm)  Erstes Schritte. Extraktion aus der prelude.R
#                      (0.1.0)
# 27. Feb. 2018  (nm)  Bugfixe und mehr Debug-Informationen
#                      (0.1.1)
# 18. Mär. 2018  (nm)  Dokumentation angepasst.
#                      (0.1.2)
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
#  "Ein Computer wird das tun, was du programmierst 
#    -- nicht das, was du willst." 
#
#                                                      -- Unbekannter Autor
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

if (!exists("prelude.rendertools")) {
  prelude.rendertools <<- "LOADED!"
  defaults.dir <- "defaults"
  inc.notes.studi <- "include-notes-studierendenversion.tex"
  inc.notes.dozi <- "include-notes-dozentenversion.tex"
  inc.notes.lsgskript <- "include-notes-loesungen.tex"
  inc.notes <- "include-notes.tex"
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  createPrivateYaml <- function(DozInfo=NULL, Semester="SoSe 2018", Standort, path=".") {
    privymlfn <- file.path(path, "private.yaml")
    file.create(privymlfn)
    if (is.null(DozInfo)) {
      tmp <- paste0(
        "---\nauthor: \"FOM\"\ndate: \"", Semester, "\"",
        "\ninstitute: \"FOM\"",
        "\n---\n"
      )
      
    } else {
      preTitel <- ""
      postTitel <- ""
      preTitels <- "[Prof|Dipl|Dr]"
      postTitels <- "[MBA|M.Sc|M.A.|B.A|MPA]"
      if (stringr::str_detect(DozInfo$Titel, preTitels)) {
        preTitle <- paste0(DozInfo$Titel, " ")
      } else if (stringr::str_detect(DozInfo$Titel, postTitels)) {
        postTitle <- paste0(" (", DozInfo$Titel, ")")
      }
      tmp <- paste0(
        "---\nauthor: \"", preTitel, DozInfo$Vorname, " ", DozInfo$Nachname, postTitel, "\"\ndate: \"", Semester, "\"",
        "\ninstitute: \"FOM ", Standort, "\"",
        "\n---\n"
      )
      
    }
    flog.info(paste0("Create '", privymlfn, "'"))
    flog.debug(paste0("Content of '", privymlfn, "':\n", tmp))
    cat(tmp, file = privymlfn)
  }

  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  createNotesIncludeFile <- function(fn, content, path=".") {
      fn <- file.path(path, fn)
      if (!file.exists(fn)) {
          flog.debug(paste0("WARNING: ",
                            "Create file `",fn,"`!"))
          cat(content, file=fn)
      }
  }  
  

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  createDoziNotes <- function(path=".") {
      createNotesIncludeFile(
          inc.notes.dozi,
            "% AUTOMATICALY CREATED!\n% DO NOT EDIT!\n\\usepackage{pgfpages}\n\\setbeameroption{show notes}\n",
            path=path)
  }
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  createStudiNotes <- function(path=".") {
      createNotesIncludeFile(
          inc.notes.studi,
          "% AUTOMATICALY CREATED!\n% DO NOT EDIT!\n\\usepackage{pgfpages}\n\\setbeameroption{hide notes}\n",
          path=path)
  }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  createLsgSkriptNotes <- function(path=".") {
    createNotesIncludeFile(
        inc.notes.lsgskript,
        "% AUTOMATICALY CREATED!\n% DO NOT EDIT!\n\\usepackage{pgfpages}\n\\setbeameroption{show only notes}\n",
        path=path)
}
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  makeDozi <- function() {
    createDoziNotes()
    doCopyAndLog(inc.notes.dozi, inc.notes)
    if (UseCache) {
        doCopyAndLog(file.path(defaults.dir, "cachecontrol-Dozi.R"), "cachecontrol.R")
    } else {
        doCopyAndLog(file.path(defaults.dir, "cachecontrol-NoCache.R"), "cachecontrol.R")
    }
  }


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  makeStudi <- function() {
    createStudiNotes()
    doCopyAndLog(inc.notes.studi, inc.notes)
    if (UseCache) {
        doCopyAndLog(file.path(defaults.dir, "cachecontrol-Studi.R"), "cachecontrol.R")
    } else {
        doCopyAndLog(file.path(defaults.dir, "cachecontrol-NoCache.R"), "cachecontrol.R")
    }
  }


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  makeLsgSkript <- function() {
      createLsgSkriptNotes()
      doCopyAndLog(inc.notes.lsgskript, inc.notes)
      if (UseCache) {
          doCopyAndLog(file.path(defaults.dir, "cachecontrol-LsgSkript.R"), "cachecontrol.R")
      } else {
          doCopyAndLog(file.path(defaults.dir, "cachecontrol-NoCache.R"), "cachecontrol.R")
      }
  }
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  cleanUp <- function(path) {
    flog.debug(paste("Remove:", file.path(path, "*_files")))
    unlink(file.path(path, "*_files"), recursive = TRUE)
  }
  # ENDE der Hilfsfunktionen
}
# ===========================================================================