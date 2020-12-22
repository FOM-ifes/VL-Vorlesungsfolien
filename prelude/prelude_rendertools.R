# ===========================================================================
# prelude_rendertools.R (Release 0.3.2)
# =====================------------------------------------------------------
# (W) by Norman Markgraf in 2018/19
#
# 23. Feb. 2018  (nm)  Erstes Schritte. Extraktion aus der prelude.R
#                      (0.1.0)
# 27. Feb. 2018  (nm)  Bugfixe und mehr Debug-Informationen
#                      (0.1.1)
# 18. Mär. 2018  (nm)  Dokumentation angepasst.
#                      (0.1.2)
# 22. Jan. 2019  (nm)  Bugfixe bzgl. Private.Yaml, Refoktoring
#                      (0.2.0)
# 11. Jun. 2019  (nm)  PreTitel und PostTitel nun in private.R!
#                      (0.3.0)
# 03. Sep. 2019  (nm)  "makeSkriptTypeOf()" ersetzt die make*() Funktionen.
#                      (0.3.1)
# 04. Sep. 2019  (nm)  "makeS*riptTypeOf()", "setTypeOfS*ript()" um *={k,c} 
#                      erweitert, damit "pseudo-native-speaker" nicht merken.
#                      Laysiness bei den drei Skriptarten erweitert. Cool man!
#                      (0.3.2)
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
#  "Ein Computer wird das tun, was du programmierst 
#    -- nicht das, was du willst." 
#
#                                                      -- Unbekannter Autor
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

library(futile.logger)

if (!exists("prelude.rendertools")) {
  prelude.rendertools <<- "LOADED!"
  defaults.dir <- "defaults"
  inc.notes.studi <- "include-notes-studierendenversion.tex"
  inc.notes.dozi <- "include-notes-dozentenversion.tex"
  inc.notes.lsgskript <- "include-notes-loesungen.tex"
  inc.notes <- "include-notes.tex"

  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  createPrivateYaml <- function(
      DozInfo=NULL, 
      Semester="SoSe 2019",
      Institute="FOM",
      Studienort="", 
      path=".",
      forced=TRUE) {
    privymlfn <- file.path(path, "private.yaml")
    if (file.exists(privymlfn) && !forced) {
        # Falls die Datei existiert und nicht unbedingt überschrieben 
        # werden soll, dann beenden!
        flog.info(paste0("File ", privymlfn, "' will not be overwritten!"))
        return(TRUE)
    }
    if (Institute != "") {
        if (Studienort != "") {
            # Falss ein Institute angegeben ist, wird es vor den Studienort gestellt.
            tmpInst <- paste(Institute, Studienort)
        } else {
            # Falls kein Studienort angegeben ist, dann nur das Institute!
            tmpInst <- Institute
        }
    } else {
        # Fall kein Institute angegeben ist, wird nur der Studienort verwendet.
        tmpInst <- Studienort
    }
    
    out <- file(privymlfn, "w", encoding = "UTF-8")
    if (is.null(DozInfo)) {
      tmp <- paste0(
        "---\nauthor: \"FOM\"\ndate: \"", Semester, "\"",
        "\ninstitute: \"", tmpInst ,"\"",
        "\n---\n"
      )
    } else {
      if (is.character(DozInfo)) {
        tmp <- paste0(
          "---\nauthor: \"", DozInfo, "\"\ndate: \"", Semester, "\"",
          "\ninstitute: \"", tmpInst ,"\"",
          "\n---\n"
        )
      } else {
        preTitel <- DozInfo$PreTitel
        postTitel <- DozInfo$PostTitel
        tmp <- paste0(
          "---\nauthor: \"", preTitel, " ", DozInfo$Vorname, " ", DozInfo$Nachname, " ", postTitel, "\"\ndate: \"", Semester, "\"",
          "\ninstitute: \"", tmpInst, "\"",
          "\n---\n"
        )
      }
    }
    flog.info(paste0("Create new '", privymlfn, "'"))
    flog.info(paste0("Content of '", privymlfn, "':\n", tmp))
    cat(iconv(tmp, to="UTF-8"), file = out)
    close(out)
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
  myLazyCompareStrings <- function(patterns, probe) {
    for (pattern in patterns) {
      if (agrepl(pattern, probe, ignore.case = TRUE)) {
        return(TRUE)
      }
    }
    return(FALSE)
  }
  
  makeSkriptOfType <- function(type="DozentenSkript") {
    if (myLazyCompareStrings(c("Dozi", "DozentenFassung", "DozentenSkript"), type)) {
      makeDozi()
    } else {
      if (myLazyCompareStrings(c("Studi", "StudentenFassung", "StudierendenSkript"), type)) {
        makeStudi()
      } else {
        if (myLazyCompareStrings(c("Lösg", "Musterlösungen", "Lsg", "LösungsSkript"), type)) {
          makeLsgSkript()
        }
      }
    }
  }
  makeScriptOfType <- makeSkriptOfType
  setTypeOfScript <- makeSkriptOfType
  setTypeOfSkript <- makeSkriptOfType
    
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  cleanUp <- function(path) {
    flog.debug(paste("Remove:", file.path(path, "*_files")))
    unlink(file.path(path, "*_files"), recursive = TRUE)
  }
  # ENDE der Hilfsfunktionen
}
# ===========================================================================