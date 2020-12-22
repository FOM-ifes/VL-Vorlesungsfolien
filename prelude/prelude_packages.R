# ===========================================================================
# prelude_packages.R (Release 0.2.0)
# ==================---------------------------------------------------------
# (W) by Norman Markgraf, Karsten Lübke in 2017/18
#
# 27. Feb. 2018  (nm)  Erstes Schritte. Extraktion aus der prelude.R
#                      (0.1.0)
# 04. Mrz. 2018  (nm)  Löschen von ungewollten oder störenden Paketen!
#                      (0.1.1)
# 18. Mär. 2018  (nm)  Dokumentation angepasst.
#                      (0.1.2)
# 18. Jan. 2019  (nm)  Version der R Pakete werden nun richtig verglichen.
#                      (0.2.0)
#
#   (C)opyleft Norman Markgraf and Karsten Lübke in 2018/19
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
# "Programs are meant to be read by humans and only incidentally for
# computers to execute."
#
#                                                           -- Donald Knuth
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

if (!exists("prelude.packages")) {
    prelude.packages <<- "LOADED!"
    if (!exists("prelude.tools")) {
        stop("FATAL ERROR: Please load prelude.tools first!")
    }
# ---------------------------------------------------------------------------
# Endung der Paket-Anforderungsdatei.
# ---------------------------------------------------------------------------
  needed_pkgs_suffix <<- ".needed_pkgs.csv"
  
  
# ---------------------------------------------------------------------------
# Pfad zu den Paket-Anforderungsdateien
# ---------------------------------------------------------------------------
  pathtoneeded_pkgs <<- "."

# ---------------------------------------------------------------------------
# Release Vergleich
# ---------------------------------------------------------------------------
releaseCompare <- function(relA, relB) {
  return (compareVersion(relA, relB) < 0)
}
  
# ---------------------------------------------------------------------------
# checkPackages
# -------------
# prüft auf das Vorhandensein von Packeten, installiert diese ggf. und/oder
# bringt sie auf einen notwendigen Stand.
#
# mit *repos* kann das Repository für die Installation gewählt werden.
# mit *noupdates=TRUE* kann man das updateted verhindern und bekommt nur eine
# Mitteilung.
#
# Lässt man den erste Parameter weg, so wird versucht die Datei prelude.csv
# zu laden. Ist dort eine Zeichekette angegeben, so wird diese als Dateiname
# interpretiert. Ist es ein DataFrame, so wird dieser als Grundlage zur
# Prüfung benutzt.
#
# ---------------------------------------------------------------------------
  checkPackages <- function(
      needed_pkgs_df = NULL, # DataFrame der benötigten Pakete
      repos = "https://cran.rstudio.com", # URL zur CRAN Repository von RStudio
      noupdates = FALSE, # Keine Updates?
      dependencies = FALSE) { # Mit "dep=T" oder ohne?
      
      message("Prüfe die Pakete ...", appendLF = FALSE)
      
      searchPath <- c(".", "prelude", file.path("..", "prelude"))
      
      # Lade die Daten für die benötigten Pakete!
      if (!is.data.frame(needed_pkgs_df)) {
          if (!is.character(needed_pkgs_df)) {
              filename <- paste0(tools::file_path_sans_ext(knitr::current_input()), needed_pkgs_suffix)
              fn <- searchFileInPath(filename, searchPath, stopOnFail=FALSE)
              if (is.null(fn)) {
                  filename <- "prelude.csv"
                  fn <- searchFileInPath(filename, searchPath, stopOnFail=FALSE)
              }
          } else {
              fn <- searchFileInPath(needed_pkgs_df, seatchPath, stopOnFail=FALSE)
          }
          if (!is.null(fn) && file.exists(fn)) {
              message(paste0(" an Hand der Datei '", fn, "'"), appendLF = FALSE)
              
              needed_pkgs_df <- read.csv(fn, stringsAsFactors = FALSE)
          }
          else {
              stop(paste0("FATAL ERROR: Die Datei '",
                          fn, "' konnte nicht geladen werden!\n\n"))
          }
      }
      else {
          message(" an Hand der übergebenen Daten", appendLF = FALSE)
      }
      
      # Installiere ggf. fehlende Pakete
      needed_pkgs <- needed_pkgs_df[needed_pkgs_df$minrelease != "-",]$packages
      unwanted_pkgs <- needed_pkgs_df[needed_pkgs_df$minrelease == "-",]$packages
      
      new.pkgs <- needed_pkgs[!(needed_pkgs %in% installed.packages())]
      del.pkgs <- unwanted_pkgs[(unwanted_pkgs %in% installed.packages())]
      print(new.pkgs)
      print(del.pkgs)
      if (length(new.pkgs)) {
          install.packages(new.pkgs, dependencies = dependencies, repos = repos)
      }
      if (length(del.pkgs)) {
          remove.packages(del.pkgs)
      }
      message("... erledigt!")
      message("Ggf. müssen noch Updates gemacht werden. Ich prüfe das ...")
      # Prüfe ob Updates nötig sind
      currel <- c()
      for (pkg in needed_pkgs_df[needed_pkgs_df$minrelease != "-",]$packages)
      {
          currel <- c(currel, paste0(packageVersion(pkg), ""))
      }
      update.pkgs <- needed_pkgs[releaseCompare(currel, as.character(needed_pkgs_df[needed_pkgs_df$minrelease != "-",]$minrelease))]
      
      # Ggf. wird hier ein Update durchgeführt oder eine Mitteilung gesendet!
      for (pkg in update.pkgs)
      {
          if (noupdates || pkg %in% loadedNamespaces()) {
              warning(paste0("WARNUNG: ",
                             "Das Paket `", pkg, "` muss upgedatet werden!"))
          }
          else {
              message("das Paket '", pkg, "' wird upgedatet ... ")
              install.packages(pkg, dependencies = dependencies, repos = repos) # besser als update.packages!
          }
      }
#      for (pkg in unwanted_pkgs$packages) {
#          if (noupdates || pkg %in% loadedNamespaces()) {
#              warning(paste0("WARNUNG: ",
#                             "Das Paket `", pkg, "` muss DEINSTALLIERT werden!"))
#          }
#          else {
#              message("das Paket '", pkg, "' wird DEINSTALLIERT ... ")
#              remove.packages(pkgrepos = repos) # WEG damit!
#          }
#      }
      message("... erledigt!")
  }
  
}
# ===========================================================================