# ===========================================================================
# prelude.R (Release 2.5.3)
# =========------------------------------------------------------------------
# (W) by Norman Markgraf, Karsten Lübke & Sebastian Sauer in 2017-21
#
# 01. Sep. 2017  (nm)  Erstes Release
#                      (Release 1.)
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
#                      (Release 2.1.0)
# 15. Jan. 2019  (nm)  Dokumentation angepasst.
#                      (Release 2.2.0)
# 16. Jan. 2019  (nm)  Refaktoring
#                      (Release 2.2.1)
# 22. Jan. 2019  (nm)  Refaktoring, RENDEREDBYSCRIPT hinzugefügt.
#                      (Release 2.3.0)
# 28. Jan. 2019  (nm)  Bugfix "rm('RENDEREDBYSCRIPT')"
#                      (Release 2.3.1)
# 03. Feb. 2019  (nm)  Nicht dauerhafte prelude funktionen automatisch
#                      löschen mit "prelude.cleanMemory <<- TRUE" 
#                      eingebaut
#                      (Release 2.3.2)
# 05. Mai  2019  (nm)  Bisher wurden die Übungensnummern mit R verwaltet.
#                      Wegen der include_exclude.py Filter nun direkt in LaTeX
#                      als Zähler dort. (beamerthemeNPBT.sty ab 4.2.1 nötig!!!)
#                      (Release 2.4.0)
# 27. Feb. 2021  (nm)  Virtuell und useR standardmässig auf FALSE gesetzt.
#                      (Release 2.4.1)
# 02. Mrz. 2021  (nm)  my.options() statt statischen Variablen
#                      (Release 2.5)
# 23. Apr. 2021  (nm)  "assign" statt "<<-"!
#                      (Release 2.5.1)
# 31. Dez. 2021  (nm)  "assertTxtData()" zum Sicherstellen von Txt-Daten aus 
#                      dem Netz
#                      (Release 2.5.2)
# 04. Jan. 2022  (nm)  assign() um ",envir = GlobalEnc" erweitert. Bugfix!
#                      (Release 2.5.3)
#
#   (C)opyleft Norman Markgraf in 2017-22
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
    stop("Please install the packages `futile.logger` (install.packages(\"futile.logger\") first!")
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

merge_list = function(x, y) {
  x[names(y)] = y
  x
}

my_defaults = function(value = list()) {
  defaults = value
  
  get = function(name, default = FALSE, drop = TRUE) {
    if (default) defaults = value  # this is only a local version
    if (missing(name)) defaults else {
      if (drop && length(name) == 1) defaults[[name]] else {
        setNames(defaults[name], name)
      }
    }
  }
  resolve = function(...) {
    dots = list(...)
    if (length(dots) == 0) return()
    if (is.null(names(dots)) && length(dots) == 1 && is.list(dots[[1]]))
      if (length(dots <- dots[[1]]) == 0) return()
    dots
  }
  set = function(...) {
    dots = resolve(...)
    if (length(dots)) defaults <<- merge(dots)
    invisible(NULL)
  }
  delete = function(keys) {
    for (k in keys) defaults[[k]] <<- NULL
  }
  merge = function(values) merge_list(defaults, values)
  restore = function(target = value) defaults <<- target
  append = function(...) {
    dots = resolve(...)
    for (i in names(dots)) dots[[i]] <- c(defaults[[i]], dots[[i]])
    if (length(dots)) defaults <<- merge(dots)
    invisible(NULL)
  }
  
  list(
    get = get, set = set, delete = delete,
    append = append, merge = merge, restore = restore
  )
}

if (!exists("my.options")) {
  assign("my.options",  my_defaults(list(
    layouttype = "FOM",        # Möglich sind: "eufom", "DLS"
    eufom = FALSE,             #
    Virtuell = TRUE,             #
    UseCache = FALSE,          #
    showuseR = TRUE, 
    overwrite_old = TRUE,      # Sollen bestehende Dateien überschrieben werden?
    use_private = TRUE,        # Die Werte aus "private/private.R" benutzen?
    privateVorstellung = TRUE, #
    showVorlesungsplan = FALSE,
    useLattice = FALSE         # Use Lattice (or if not use ggplot)
  )), envir = .GlobalEnv)
}

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
# GLOBALE Variabeln, daher assign() statt  <<- oder <- !
# ---------------------------------------------------------------------------
assign("DEBUGMASTERFLAG", FALSE)
assign("prelude.cleanMemory", TRUE)  # Nach Benutzung ggf. unnütz gewordene 
                              # prelude-Funktionen aus dem Speicher löschnen?
if (!exists("FOMLayout")) assign("FOMLayout", TRUE)
assign("EUFOMLayout", !FOMLayout)

if (!exists("runCount")) {
  assign("runCount", 0)
}

# ---------------------------------------------------------------------------
# initPrelude
# -----------
# Diese Funktion stellt sicher, dass alle globalen Variabeln korrekt gesetzt
# sind. Sie sollte zu Beginn einer Rmd-Master-Datei ausgeführt werden.
# ---------------------------------------------------------------------------
initPrelude <- function(
                        prefix = "prefixZeit", # Prefix für das aktuelle Dokument
                        doCheckPackages = TRUE, # Sollen die Pakete geprüft werden?
                        initSeed = 1896, # Random Seed setzen auf ...
                        basePath = ".") { 

  assign("owrOwnBasePath", basePath, envir = .GlobalEnv)
  assign("prefixZeit", prefix, envir = .GlobalEnv)


  if (!exists("Vorlesungstermine")) {
      assign("Vorlesungstermine", "default")
  }
  
  # Standardeinstellungen für useR und Virtuell Variablen
  if (!exists("showuseR")) assign("showuseR", FALSE, envir = .GlobalEnv)
  if (!exists("Virtuell")) assign("Virtuell", FALSE, envir = .GlobalEnv)
  
  assign("kap", -1, envir = .GlobalEnv)
  assign("ex", 0, envir = .GlobalEnv)

  # Keine Ahnung wofür das ist ***KL***??
  assign("abschluss", FALSE, envir = .GlobalEnv)
  assign("WDH", "Wiederholung: ", envir = .GlobalEnv)
  
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

  # Prüfen ob private.yaml existiert und ggf. mit Dafaultwerten füllen!
  if (!file.exists("private.yaml")) {
      cat("---\nauthor: \"FOM Dozent\\*in\"\ndate: \"\"\ninstitute: \"FOM\"\n---\n", file="private.yaml")
  }

  # Notwendige Pakete überprüfen und ggf. installieren.
  if (doCheckPackages) {
    checkPackages()
  }

  if (!exists("RENDEREDBYSCRIPT")) {
      assign("RENDEREDBYSCRIPT", FALSE, envir = .GlobalEnv)
  }
  
  # Auf private Dateien (private.R,  und private.yaml) prüfen und ggf. laden.
  checkPrivateFiles(c("private-Semesterdaten.R"), path="private")
  
  preludeFilelist <- c("prelude_timetable.R",
                       "prelude_timetable.R",
                       "prelude_images.R",
                       "prelude_python.R",
                       "prelude_panflute.R"
                       )
  for(preludeFile in preludeFilelist){
      loadPrelude(preludeFile)
  }

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
  assign("kap", -1, envir = .GlobalEnv)
  assign("ex", 0, envir = .GlobalEnv)
  assign("abschluss", FALSE, envir = .GlobalEnv)
  assign("runCount", 0, envir = .GlobalEnv)
  if (exists("RENDEREDBYSCRIPT")) {
      rm("RENDEREDBYSCRIPT", inherits = TRUE, envir = .GlobalEnv)
  }
}

assign("runCount", get("runCount") + 1, envir = .GlobalEnv)
if (get("runCount") > 2) {
  assign("runCount", 2, envir = .GlobalEnv)
}

# ---------------------------------------------------------------------------
# ownChapter steuert die Lübke'sche Kapitelverwaltung. (DEPRECATED!)
# ---------------------------------------------------------------------------
assign("ownChapter", FALSE, envir = .GlobalEnv) # Verwaltung der Kapitel durch LaTeX
nextChapter <- function() {
    return("")
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
  # ex <<- ex + 1
  # return(thisExercise())
  return(paste0("\\nextExercise"))
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
  #return(paste0(ex, ""))
  return(paste0("\\thisExercise"))
}


# ---------------------------------------------------------------------------
# assertData (csv, url)
# ---------------------------------------------------------------------------
assertData <- function(
                       csv,
                       url,
                       debug = FALSE,
                       stringsAsFactors = FALSE,
                       lang = "de") {
  td <- try(read.csv2(csv, stringsAsFactors = stringsAsFactors), silent = !debug)
  if (class(td) == "try-error") {
    if (debug) message(paste("Die Tabelle", csv, "wird von", url, "nachgeladen!"))
    download.file(url, destfile = csv)
  }
  if (lang == "de") {
    out_file <- read.csv2(csv, stringsAsFactors = stringsAsFactors)
  } else {
    out_file <- read.csv(csv, stringsAsFactors = stringsAsFactors)
  }
  return(out_file)
}

# ---------------------------------------------------------------------------
# assertTxtData (txt, url)
# ---------------------------------------------------------------------------
assertTxtData <- function(
    txt,
    url,
    debug = FALSE,
    stringsAsFactors = FALSE,
    lang = "de") {
    td <- try(read.table(txt, stringsAsFactors = stringsAsFactors), silent = !debug)
    if (class(td) == "try-error") {
        if (debug) message(paste("Die Tabelle", txt, "wird von", url, "nachgeladen!"))
        download.file(url, destfile = txt)
    }
    read.table(txt, stringsAsFactors = stringsAsFactors)
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
    assign("curPart.name", "", envir = .GlobalEnv)
    assign("curPart.subdirname", subdirname, envir = .GlobalEnv)
    if (!is.null(partname)) {
        assign("curPart.name",partname, envir = .GlobalEnv)
    }
    flog.debug(paste0("Starte mit Datei '", get("curPart.name"), ".Rmd'"))
    x <- paste0("'", paste(search(), collapse = "', '"), "'")
    flog.debug(paste("Aktueller Suchpfad:", x))
    x <- paste0("'", paste(loadedNamespaces(), collapse = "', '"), "'")
    flog.debug(paste("Aktueller Namespaces", x))
}

# ---------------------------------------------------------------------------
# finalizePart
# ---------------------------------------------------------------------------
finalizePart <- function(partname=NULL, debug=FALSE) {
    x <- paste0("'", paste(search(), collapse = "', '"), "'")
    flog.debug(paste("Aktueller Suchpfad:", x))
    flog.debug(paste0("Ende mit Datei '", get("curPart.name"),".Rmd'!"))
    x <- paste0("'", paste(loadedNamespaces(), collapse = "', '"), "'")
    flog.debug(paste("Aktueller Namespaces", x))
    
    assign("curPart.name", NULL, envir = .GlobalEnv)
    assign("curPart.subdirname", NULL, envir = .GlobalEnv)
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
# ---------------------------------------------------------------------------
# ================== Ergänzungen mg ==================

# ---------------------------------------------------------------------------
#
# Text aus Summary auslesen
#
# Parameter: Model, starttext, endtext (optional)
# starttext kann auch eine Zahl, dann wird ab dieser Zeile ausgegeben
# endtext kann auch eine Zahl sein, dann werden endtext Zeilen nach starttext ausgegeben
# es wird jeweils das erste Auftreten des gesuchten Textes genommen
# flsumy: TRUE - output von summary(mod), FALSE - direkt output von mod
# Etwas Fehlerbehandlung implementiert
# ---------------------------------------------------------------------------
getSumLines <- function(mod, starttext, endtext = "", flsumy = TRUE) {
    # Umwandeln des summary in text
    if (flsumy)
        # Summary nutzen
        sumytxt <- capture.output(summary(mod))
    else
        # direkt Output des Modells nutzen
        sumytxt <- capture.output(mod)
    
    if (is.numeric(starttext))
        lStart <- starttext
    else{
        lStart <- grep(starttext, sumytxt)
        if (!length(lStart)) {
            cat("Starttext nicht gefunden!\n")
            return
        }
        # wenn mehr als eine Stelle gefunden wurde, die erste nehmen
        lStart <- lStart[1]
    }
    
    if (endtext != "") {
        if (is.numeric(endtext)) {
            lEnd <- lStart + endtext
        }
        else {
            lEnd <- grep(endtext, sumytxt)
            lEnd <- lEnd[1]
        }
        if (!length(lEnd)) {
            cat("Endtext nicht gefunden!\n")
            return
        }
        if (lEnd > lStart)
            cat(sumytxt[lStart:lEnd], sep = "\n")
        else
            cat(sumytxt[lEnd:lStart], sep = "\n")
    }
    else
        cat(sumytxt[lStart])
}

# ===========================================================================