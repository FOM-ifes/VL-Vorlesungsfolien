# MakeMySemester.R
# ================-----------------------------------------------------------
#
# (C) in 2018-19 by Norman Markgraf (nmarkgraf@hotmail.com)
#
# Dieses Skript erstellt die notwenidigen, personalisierten Skripte für alle
# Dozenten und verschickt diese automatisch an diese.
#
#
#   (C)opyleft Norman Markgraf in 2018-19
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
# "Programmieren ist wie Küssen:
#  Man kann darüber reden, man kann es beschreiben,
#  aber man weiß erst was es bedeutet, wenn man es getan hat."
#
#                                               -- Andrée Beaulieu-Green
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# ---------------------------------------------------------------------------
#
# Die benötigten Pakete von R sind:
#
library(readxl)
library(dplyr)
library(tidyr)
library(rmarkdown)
library(methods)
library(readxl)
## Wird vielleicht einmal benötigt werden, wenn man automatisiert von der 
## Fertigstellung benachrichtigt werden will ...
#library(mailR) 
# ---------------------------------------------------------------------------
# Logging für Anfänger
library(futile.logger)
build.logfile <<-"MakeMySemester.log"
# ICH HASSE ES, dass man hier `getwd()` nutzen MUSS! 
# Aber ich finde keinen anderen Weg, der *immer* funktioniert!
build.logdir <<- file.path(getwd(),"log")
if (!dir.exists(build.logdir)) {
    dir.create(build.logdir)
}
if (!file.exists(file.path(build.logdir, build.logfile))) {
    cat("Fresh created Log-File!", file=file.path(build.logdir, build.logfile))
}
flog.appender(appender.file(file.path(build.logdir, build.logfile)))
flog.threshold(INFO) # Ab DEBUG aufwärts - Probleme suchen und beheben.
# ---------------------------------------------------------------------------

source("prelude/prelude_tools.R")

build.dir <<- "build"
build.basedir <<- "."

#
# Make Semester
#
loadPrelude("prelude_rendertools.R")
loadPrelude("prelude_prefixeRmd.R")
UseCache <<- TRUE
loadPrivate("private.R")
loadPrivate("private-Semesterdaten.R")


doRender <- function(rmdfile, target=NULL, outfile=NULL, output_format="beamer_presentation") {
    flog.debug(paste0("doRender(",rmdfile,", ",target,", ",outfile,") called."))
# # renderEnv <- new.env(hash=TRUE, parent = baseenv())
# # renderEnv <- new.env(hash=TRUE, parent = globalenv())
    
    # Neue Umgebung erschaffen und dann soweit löschen wie möglich und nötig.
    # Somit bekommt jeder neue Renderprozess eine saubere Umgebung!
    renderEnv <- globalenv()
    RENDEREDBYSCRIPT <<- TRUE
    assign("RENDEREDBYSCRIPT", TRUE, envir=renderEnv)
#    rm(list = ls(renderEnv), envir = renderEnv)
    rm(list = ls(), envir = renderEnv)
    rmarkdown::render(
        input = rmdfile,
        output_format = output_format,
        output_file = outfile,
        output_dir = target,
        envir = renderEnv,
        encoding = "UTF-8"
    )
}

doCleaningAfterAll <- function(proper=TRUE) {
    if (proper) {
        # clean all cache dirs
        unlink("__cache", recursive=TRUE, force=TRUE)
        unlink("__cache_dozi", recursive=TRUE, force=TRUE)
        unlink("__cache_studi", recursive=TRUE, force=TRUE)
        unlink(file.path(build.dir,"*-*-*VERSION.pdf"), recursive=TRUE, force=TRUE)
        unlink(file.path(build.dir,"*-*-*Loesungen.pdf"), recursive=TRUE, force=TRUE)
    }
    unlink(file.path(build.dir,"*_files"), recursive=TRUE, force=TRUE)
    unlink(file.path(build.dir,"*-*-*VERSION.tex"), recursive=TRUE, force=TRUE)
    unlink(file.path(build.dir,"*-*-*Loesungen.tex"), recursive=TRUE, force=TRUE)
}

doTestMain <- function(builddir = build.dir, buildbasedir = build.basedir, cleanup=TRUE) {
    if (packageVersion("rmarkdown") < "1.9.2") {
        stop("FATAL ERROR: You must update the package 'rmarkdown' to at least 1.9.2 or newer!")
    }
    createPrivateYaml(NULL, "Test", "Test")
    showVorlesungsplan <<- FALSE
    Vorlesung <- "Wissenschaftliche-Methodik"
    pptxpath <- pdfpath <- file.path(buildbasedir, builddir)
    pptxfilename <- paste0(Vorlesung,"-", "TEST","-STUDIERENDENVERSION.pptx")
    pptxfn <- file.path(pptxpath, pptxfilename)
    rmdfn <- file.path(buildbasedir, paste0(Vorlesung, ".Rmd"))
    makeStudi()
    flog.debug(paste(rmdfn, pptxpath, pptxfilename))
    doRender(rmdfn, pptxpath, pptxfilename, "powerpoint_presentation")
}

doMain <- function(
        builddir = build.dir, 
        buildbasedir = build.basedir, 
        startWithCleanLog=FALSE,
        cleanStart=FALSE, 
        cleanup=TRUE) {
    if (cleanStart) {
        flog.logger()
    }
    
    if (startWithCleanLog) {
        logfn <- file.path(build.logdir, build.logfile)
        if (file.exists(logfn)) {
            unlink(logfn)
        }
    }
    
    for(i in seq(along=semesterdaten$Vorlesung)) {

        if (!hasName(semesterdaten, "OrtGruppe")) {
            flog.info("In 'private-Semesterdaten.R' fehlt die Spalte 'OrtGruppe'! Kopiere die Daten aus 'Ort' in diese Spalte!")
            semesterdaten %>% mutate(OrtGruppe = Ort) -> semesterdaten
        }
        
        createPrivateYaml(DozInfo, semesterbezeichner, semesterdaten$Ort[i], forced = TRUE)
        
        Ort <- transUmlaute(semesterdaten$OrtGruppe[i])
        Vorlesungstermine <<- Ort
        showVorlesungsplan <<- TRUE
        
        if (hasName(semesterdaten, "Zeitplan") && !is.null(semesterdaten$Zeitplan[i])) {
            showVorlesungsplan <<- semesterdaten$Zeitplan[i]
        }

        if (hasName(semesterdaten, "Vorstellung") && !is.null(semsterdaten$Vorstellung)) {
            privateVorstellung <<- semesterdaten$Vorstellung
        } else {
            if (hasName(DozInfo, "privateVorstellung")) {
                privateVorstellung <<- DozInfo$privateVorstellung
            }
        }
        
        pdfprefilename <- semesterdaten$Vorlesung[i]
        if (Ort != "") {
            pdfprefilename <- paste0(semesterdaten$Vorlesung[i], "-", Ort)
        }
    
        
        if ((hasName(semesterdaten, "Dozentenversion")) && (semesterdaten$Dozentenversion[i])) {
            pdfpath <- file.path(buildbasedir, builddir)
            pdffilename <- paste0(pdfprefilename,"-DOZENTENVERSION.pdf")
            pdffn <- file.path(pdfpath, pdffilename)
            rmdfn <- file.path(buildbasedir, paste0(semesterdaten$Vorlesung[i], ".Rmd"))
            flog.info(paste0("Erzeuge '",pdffilename,"' mit Vorlesungsplan ",showVorlesungsplan))
            if (!file.exists(pdffn) || cleanStart) {
                makeDozi()
                flog.debug(paste(rmdfn, pdfpath, pdffilename))
                doRender(rmdfn, pdfpath, pdffilename)
            }
        }

        if ((hasName(semesterdaten, "Studierendenversion")) && (semesterdaten$Studierendenversion[i])) {
            pdfpath <- file.path(buildbasedir, builddir)
            pdffilename <- paste0(pdfprefilename,"-STUDIERENDENVERSION.pdf")
            pdffn <- file.path(pdfpath, pdffilename)
            rmdfn <- file.path(buildbasedir, paste0(semesterdaten$Vorlesung[i], ".Rmd"))
            flog.info(paste0("Erzeuge '",pdffilename,"' mit Vorlesungsplan ",showVorlesungsplan))
            if (!file.exists(pdffn) || cleanStart) {
                makeStudi()
                flog.debug(paste(rmdfn, pdfpath, pdffilename))
                doRender(rmdfn, pdfpath, pdffilename)
            }
        }
        
        if ((hasName(semesterdaten, "LsgSkript")) && (semesterdaten$LsgSkript[i])) {
            pdfpath <- file.path(buildbasedir, builddir)
            pdffilename <- paste0(pdfprefilename,"-Loesungen.pdf")
            pdffn <- file.path(pdfpath, pdffilename)
            rmdfn <- file.path(buildbasedir, paste0(semesterdaten$Vorlesung[i], ".Rmd"))
            flog.info(paste0("Erzeuge '",pdffilename,"' mit Vorlesungsplan ",showVorlesungsplan))
            if (!file.exists(pdffn) || cleanStart) {
                makeLsgSkript()
                flog.debug(paste(rmdfn, pdfpath, pdffilename))
                doRender(rmdfn, pdfpath, pdffilename)
            }
        }
        
        #if (hasName(semesterdaten, "Schleife")) {
        if (FALSE) { # Ausmarkiert, weil es z.Z. nicht mit den Logfiles funktioniert!
            if (semesterdaten$Schleife[i]) {
                pdfpath <- file.path(buildbasedir, builddir)
           
                prefixSchleife <- prefixeRmd[semesterdaten$Vorlesung[i]]
                if (is.na(prefixSchleife)) {
                    flog.error("Prefix für Schleife konnte nicht gefunden werden! Es wird keine Schleife erzeugt!")
                } else {
                    names(prefixSchleife) <- NULL
                    rmdfn <- file.path(buildbasedir, "Schleifen", paste0(prefixSchleife,"-Schleife.Rmd"))
                    pdffilename <- paste0(pdfprefilename,"-Schleife.pdf")
                    pdffn <- file.path(pdfpath, pdffilename)
                    flog.debug(paste("Erzeuge Schleife für die Vorlesung ", semesterdaten$Vorlesung[i]))
                    if (!file.exists(pdffn) || cleanStart) {
                        makeStudi()
                        flog.debug(paste(rmdfn, pdfpath, pdffilename))
                        doRender(rmdfn, pdfpath, pdffilename)
                    }            
                }
            }
        }
    }
    if (cleanup) {
        doCleaningAfterAll(proper=FALSE)
    }
}

#doTestMain()
#doMain(cleanup = FALSE) # Für DEBUG-Zwecke!
doMain(startWithCleanLog=TRUE)

