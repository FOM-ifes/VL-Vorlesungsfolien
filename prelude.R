# ===========================================================================
# prelude.R (Release 2.0)
# =========------------------------------------------------------------------
# (W) by Norman Markgraf, Karsten Lübke & Sebastian Sauer in 2017/18
#
# 01. Sep. 2017  (nm)  Erstes Release (1.0)
# 02. Sep. 2017  (nm)  Dokumentation erweitert und Bugfixes
# 11. Sep. 2017  (nm)  Funktion "getPathToImages" eingebaut
#                      (Release 1.1)
# 20. Sep. 2017  (nm)  Dokumentation für einige Funktion im R-Style
#                      eingebaut.
#                      (Release 1.2)
# 09. Nov. 2017  (nm)  Kleinere Anpassungen
#                      (Release 1.3)
# 15. Nov. 2017  (nm)  Die Funktionen "initPrelude" und "finalizePrelude"
#                      sollten als erstes und letztes von der Rmd-Datei
#                      aufgerufen werden.
#                      (Release 1.4)
# 20. Nov. 2017  (nm)  Codename: Environment-Debugger
#                      (Release 1.5)
# 22. Nov. 2017  (nm)  Paketaktualisierung verbessert
#                      (Release 1.6)
# 28. Nov. 2017  (nm)  Timetable mit XSLX füttern.
#                      (Release 1.7)
# 20. Jan. 2018  (rm)  Anpassung trellis color an FOM CD
#                      (Release 1.8)
# 23. Jan. 2018  (kl)  Ergänzungen "Wiederholung: Organisatorisches" zum
#                      Abschluss
#                      (Release 1.9)
# 30. Jan. 2018  (nm)  Aufräumen ist angesagt! Erster Schritt mehr in diese
#                      Datei zu verlagern und den Quelltext zu straffen und
#                      zu säubern.
#                      (Release 1.9.1)
# 19. Feb. 2018  (nm)  Alle private*.* Dateien prüfen und ggf. den Dozenten warnen.
#                      Die Dateien `private.yaml`, `private.R` und `private-mail.R`
#                      haben nichts im Repository zu suchen. Dort sind nur die
#                      `*_default.* Varianten zugelassen!
#                      (Release 1.9.2)
# 19. Feb. 2018  (nm)  Bugfixe 
#                      (Release 1.9.2.1)
# 21. Feb. 2018  (nm)  Vorlesungsplan (aka timetable) in eigenes Rskript 
#                      (prelude/prelude_timetable.R) ausgelagert!
#                      (Release 2.0)
# 18. Mär. 2018  (nm)  Dokumentation angepasst.
#                      (2.1.0)
#
#   (C)opyleft Norman Markgraf in 2017/18
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
# "Programs are meant to be read by humans and only incidentally for
# computers to execute."
#
#                                                           -- Donald Knuth
#
# ===========================================================================

# ---------------------------------------------------------------------------
# Logging für Anfänger
if (!requireNamespace('futile.logger', quietly = TRUE)) {
    stop("Please install the packages `futile.logger` (install.packages(\"futile.logger\")")
}
library(futile.logger)

# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Standardeinstellungen für knitr
# ---------------------------------------------------------------------------
library(knitr)

knitr::opts_chunk$set(
  echo = TRUE,
  background = "#ECF2F8", # war mal: '#E0E0E0',
  concordance = TRUE,
  #    out.width="80%",
  tidy = FALSE,
  fig.align = "center",
  #    fig.asp = .618,
  message = FALSE,
  warning = FALSE,
  width.cutoff = 70
)


# ---------------------------------------------------------------------------
# Falls die Datei "cachecontrol.R" existiert, wird diese nachgeladen.
# In dieser Datei kann eine Steuerung für den Cache von knitr hinterlegt
# werden.
# ---------------------------------------------------------------------------
if (file.exists("cachecontrol.R")) {
  source("cachecontrol.R")
}

# ---------------------------------------------------------------------------
# Standardeinstellungen für mosaic
# ---------------------------------------------------------------------------
library(mosaic)

# ---------------------------------------------------------------------------
# Standardeinstellung für die Ausgabe von R:
# ---------------------------------------------------------------------------
options(width = 73) # Ausgabe auf 73 Zeichen pro Zeile begrenzen.

# ---------------------------------------------------------------------------
# GLOBALE Variabeln, daher mit <<- stat <- !
# ---------------------------------------------------------------------------
DEBUGMASTERFLAG <<- FALSE

if (!exists("runCount")) {
  runCount <<- 0
}

# ---------------------------------------------------------------------------
# initPrelude
# -----------
# Diese Funktion stellt sicher, dass alle globalen Variabeln korrekt gesetzt
# sind. Sie sollte zu Beginn einer Rmd-Master-Datei ausgeführt werden.
# ---------------------------------------------------------------------------
initPrelude <- function(
                        prefix = prefixZeit, # Prefix für das aktuelle Dokument
                        doCheckPackages = TRUE, # Sollen die Pakete geprüft werden?
                        initSeed = 1896, # Random Seed setzen auf ...
                        basePath = ".") { 

  owrOwnBasePath <<- basePath 
  prefixZeit <<- prefix

  privateVorstellung <<- TRUE
  showVorlesungsplan <<- FALSE
  
  showuseR <<- TRUE
  
  kap <<- -1
  ex <<- 0

  # Keine Ahnung wofür das ist ***KL***??
  abschluss <<- FALSE
  WDH <<- "Wiederholung: "

  message("load prelude tools")
  if (file.exists("prelude/prelude_tools.R")) {
      source("prelude/prelude_tools.R", verbose=T)
  } else {
      if (file.exists("../prelude/prelude_tools.R")) {
          source("../prelude/prelude_tools.R", verbose=T)
      } else {
          print(getwd())
      }
  }

  loadPrelude("prelude_packages.R")

  # Prüfen ob private.yaml existiert und ggf. default einsetzen!
  if (!file.exists("private.yaml")) {
      cat("---\nauthor: \"FOM Dozent\"\ndate: \"\"\ninstitute: \"FOM\"\n---\n", file="private.yaml")
  }

  # Notwendige Pakete überprüfen und ggf. installieren.
  if (doCheckPackages) {
    checkPackages()
  }

  # Auf private Dateien (private.R,  und private.yaml) prüfen und ggf. laden.
  checkPrivateFiles(c("private-Semesterdaten.R"), path="private")
  
  loadPrelude("prelude_timetable.R")

  loadPrelude("prelude_images.R")
  
    
  # Random Seed setzen
  set.seed(initSeed)
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Liefert zu einer Dateinamen den Namen der "_default"-Datei
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
defaultFilename <- function(filename) {
  fn <- basename(filename)
  parts <- stringr::str_split(fn, stringr::regex("\\."))
  return(paste0(parts[[1]][1], "_default.", parts[[1]][2]))
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Prüft eine Datei auf existens, bricht mit Fehlermeldung ab, wenn diese
# nicht vorhanden ist. Ansonsten läd sie die zuerste die "_default" Fassung
# und danach die Datei selber.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
checkAndLoadPrivateFile <- function(filename, path=".") { # future: path="private") {
    loadPrivate("private_default.R", stopOnFail=TRUE) 
    loadPrivate("private.R", stopOnFail=FALSE)
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Persönliche Einstellungen sind nun in der Datei "private.R" bzw.
# "private.yaml"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkPrivateFiles <- function(addPrivateFiles = NULL, path=".") {  #  path="private") {
  privateFiles <- c("private.R", addPrivateFiles) # "private_mail.R"
  for (pf in privateFiles) {
    checkAndLoadPrivateFile(pf, path)
  }
}


# -------------^--------------------------------------------------------------
# finalizePrelude
# ---------------
# Diese Funktion stellt sicher, dass alle globalen Variabeln wieder auf
# die Startwerte gesetzt werden. Sie sollte als letzter Funktionsaufruf in
# einer Rmd-Master-Datei stehen.
# ---------------------------------------------------------------------------
finalizePrelude <- function() {
  kap <<- -1
  ex <<- 0
  abschluss <<- FALSE
  runCount <<- 0
}

runCount <<- runCount + 1
if (runCount > 2) {
  runCount <<- 2
}

# In private.R ausgelagert
# cacheVorlesungstermineDefault <<- FALSE K
# timetabletypedefault <<- "png" # oder "kntir"

# ---------------------------------------------------------------------------
# ownChapter steuert die Lübke'sche Kapitelverwaltung.
# ---------------------------------------------------------------------------
# ownChapter <- TRUE   # Verwaltung der Kapitel durch R (Lübke-default)
ownChapter <- FALSE # Verwaltung der Kapitel durch LaTeX

# ---------------------------------------------------------------------------
# Das nächste Kapitel bitte ...
# ---------------------------------------------------------------------------
#' next Chapter
#'
#' \code(nextChapter) will return the next chpater number, if in KL mode or
#' nothing.
#'
#' @return A string with the next chapter (in KL mode) or nothing (in LaTeX mode)
#'
#' @examples
#' r nextChapter` New Chapter!
#'
#
nextChapter <- function() {
  kap <<- kap + 1
  if (ownChapter) {
    return(paste0(kap, ": "))
  }
  else {
    return("")
  }
}

# ---------------------------------------------------------------------------
# Die nächste Übung ...
# ---------------------------------------------------------------------------
#' next Exercise
#'
#' \code(nextExercise) will return the next exercise number
#'
#' @return A string with the next exercise number
#'
#' @examples
#' ## Exercise No. 'r nextExercise`: A new Exercise!
#
nextExercise <- function() {
  ex <<- ex + 1
  return(thisExercise())
}

# ---------------------------------------------------------------------------
# Die aktuelle Übung ...
# ---------------------------------------------------------------------------
#' Current Exercise
#'
#' \code(thisExercise) will return the current exercise number
#'
#' @return A string with the current exercise number
#'
#' @examples
#' ## Still exercise No. 'r thisExercise`!
#
thisExercise <- function() {
  return(paste0(ex, ""))
}


# ---------------------------------------------------------------------------
# assertData (csv, url)
# ---------------------------------------------------------------------------
assertData <- function(
                       csv,
                       url,
                       debug = FALSE,
                       lang = "de") {
  td <- try(read.csv2(csv), silent = !debug)
  if (class(td) == "try-error") {
    if (debug) message(paste("Die Tabelle", csv, "wird von", url, "nachgeladen!"))
    download.file(url, destfile = csv)
  }
  if (lang == "de") {
    out_file <- read.csv2(csv)
  } else {
    out_file <- read.csv(csv)
  }
  return(out_file)
}


# ---------------------------------------------------------------------------
# getPathToBase
# ---------------------------------------------------------------------------
getPathToBase <- function() {
  pathBase <- owrOwnBasePath
  return(pathBase)
}

# ---------------------------------------------------------------------------
# getPathToImages
# ---------------------------------------------------------------------------
getPathToImages <- function(chapter = NULL) {
  cpt <- chapter
  if (is.null(chapter)) {
    cpt <- curPart.subdirname
  }
  return(file.path(".", "images", cpt))
#  return(paste0(file.path(getPathToBase(), "images", cpt),"/"))
}

# ---------------------------------------------------------------------------
# initPart
# ---------------------------------------------------------------------------
initPart <- function(
                     partname = NULL,
                     subdirname = "",
                     debug = FALSE) {
    curPart.name <<- ""
    curPart.subdirname <<- subdirname
    if (!is.null(partname)) {
        curPart.name <<- partname
    }
    flog.debug(paste0("Starte mit Datei '", curPart.name, ".Rmd'"))
    x <- paste0("'", paste(search(), collapse="', '"), "'")
    flog.debug(paste("Aktueller Suchpfad:", x))
    x <- paste0("'", paste(loadedNamespaces(), collapse="', '"), "'")
    flog.debug(paste("Aktueller Namespaces", x))
}

# ---------------------------------------------------------------------------
# finalizePart
# ---------------------------------------------------------------------------
finalizePart <- function(partname=NULL, debug=FALSE) {
    x <- paste0("'", paste(search(), collapse="', '"), "'")
    flog.debug(paste("Aktueller Suchpfad:", x))
    flog.debug(paste0("Ende mit Datei '", curPart.name,".Rmd'!"))
    x <- paste0("'", paste(loadedNamespaces(), collapse="', '"), "'")
    flog.debug(paste("Aktueller Namespaces", x))
    
    curPart.name <<- NULL
    curPart.subdirname <<- NULL
}
# ---------------------------------------------------------------------------
# setupFOMColors
# --------------
# Passt einige Mosaic/ Lattice/ Trellis Graphiken an das FOM CD an.
# ---------------------------------------------------------------------------
setupFOMColors <- function() {
  library(mosaic)

  FOMColor.line <- "#00998A"
  FOMColor.polygon.col <- "#BFE5E2"
  FOMColor.polygon.border <- "#007368"

  trellis.par.set(
    list(
      add.line = list(col = FOMColor.line),
      plot.polygon = list(col = FOMColor.polygon.col, border = FOMColor.polygon.border),
      box.rectangle = list(col = FOMColor.polygon.border),
      box.umbrella = list(col = FOMColor.polygon.border),
      box.dot = list(col = FOMColor.polygon.border),
      plot.line = list(col = FOMColor.line),
      plot.symbol = list(col = FOMColor.polygon.border),
      dot.symbol = list(col = FOMColor.line),
      dot.line = list(col = FOMColor.polygon.border),
      superpose.line = list(col = FOMColor.line)
    )
  )
}


# ===========================================================================