# ------------------------------------------------------------------------
# makerender.R                              Version 1.2.1 - 25. Feb. 2020
# ============------------------------------------------------------------
#
# (C) by N. Markgraf & M. Gehrke in 2019-2020
#
# Kleines R-Skript zum erstellen von Dozenten- / Studierenden- und
# Lösungsskript aus einer R markdown Datei ohne dass mehrfach geknitert
# werden muss.
#
# Idee: Matthias Gehrke
#
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
# Aufruf für ein Rmarkdown als R Skript:
# Rscript --vanilla makerender.R Wissenschaftliche-Methodik
# ------------------------------------------------------------------------

arguments <- commandArgs(trailingOnly=TRUE)
if (length(arguments) > 0) {
  filename <- arguments[1]
  if (length(arguments) > 1) {
    skiptsOnly <- arguments[2:length(arguments)]
  }
}

# ------------------------------------------------------------------------
# Default Dateiname (ohne ".Rmd") der übersetzt werden soll:
# ------------------------------------------------------------------------
#filename <- "Datenerhebung-Statistik"
if (!exists("filename")) {
  filename <- "Wissenschaftliche-Methodik"
  # filename <- "MathGrundlDWInfo"
  # filename <- "Datenerhebung-Statistik"
  # filename <- "QM-Wirtschaftsinformatik"
  # filename <- "Etwas-R-am-Abend"
}
cat(paste0("makerender ", filename,".Rmd\n"))

# ------------------------------------------------------------------------

overwrite_old <- TRUE   # Sollen bestehende Dateien überschrieben werden?
use_private <- FALSE     # Die Werte aus "private/private.R" benutzen?
Semester <- "SoSe 2021"  # Semesterangabe (SoSe XXXX / WiSe XXXX/XX)
#Studienort <- "Wuppertal / Gütersloh"  # Studienort(e)
#Studienort <- "Düsseldorf"
Studienort <- "FOM"
midfix <- "" # Anhängsel an den Dateinamen, falls benötigt.
#
#
if (filename == "Etwas-R-am-Abend") {
  privateVorstellung <<- TRUE  # Zeige die Private Vorstellung
  showVorlesungsplan <<- FALSE  # Zeige den Vorlesungsplan
  useLattice <<- FALSE          # ... ggformula zur Darstellung
  useCrashKurs <<- TRUE
  UseCache <<- FALSE
}

# ------------------------------------------------------------------------
# Hiermit werden die Einstellungen im Rmd-Skript übersprungen:

RENDEREDBYSCRIPT <<- TRUE

# ------------------------------------------------------------------------
# Die wichtigesten Prelude-Skripte schon einmal laden:
source("prelude/prelude_tools.R")
source("prelude/prelude_rendertools.R")

# ------------------------------------------------------------------------
# Die im Skript übersprungenen Einstellungen müssen nun nachgeholt werden:

UseCache <<- FALSE

privateVorstellung <<- TRUE   # Zeige die Private Vorstellung
showVorlesungsplan <<- FALSE  # Zeige den Vorlesungsplan
showuseR <<- TRUE             # Zeige Umfrage an

# Default Werte für "private.yaml":
if (use_private) {
  source("private/private.R")
  createPrivateYaml(DozInfo, Semester, "FOM", Studienort)
} else {
  createPrivateYaml("Dozent*in", Semester, "FOM", Studienort)
}

# ------------------------------------------------------------------------
# Aus dem angegebenen Dateinamen werden einige abgeleitete
# Dateinamen erzeugt:

filename_rmd <- paste0(filename, ".Rmd")
filename_tex <- paste0(filename, ".tex")
filename_pdf <- paste0(filename, ".pdf")
filename_dozi <- paste0(filename, midfix, "-Dozifassung.pdf")
filename_studi <- paste0(filename, midfix, "-Studifassung.pdf")
filename_lsg <- paste0(filename, midfix, "-Lsg.pdf")

# ------------------------------------------------------------------------
# Lokale Funktion, werche die externen Dateien anpasst:

compileTeXFile <- function(texfile, pdffilesource, pdffiledest,
                           msg = "", ovrwrt = TRUE) {
  cat(paste0(msg,"\n"))
  tinytex::latexmk(texfile)
  file.copy(pdffilesource, pdffiledest, overwrite = ovrwrt)
}

# ------------------------------------------------------------------------
### HAUPTROUTINE ###
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
# Dozentenskript erzeugen

makeSkriptOfType("DozentenSkript")

cat("Render and compile dozi file!\n")

rmarkdown::render(
    input = filename_rmd,
    encoding = "UTF-8",
    clean = FALSE
  )

file.copy(filename_pdf, filename_dozi, overwrite = overwrite_old)


# ------------------------------------------------------------------------
# Studierendenskript erzeugen

makeSkriptOfType("StudierendenSkript")
compileTeXFile(filename_tex, filename_pdf, filename_studi,
               "Compile studi file!", overwrite_old)

# ------------------------------------------------------------------------
# Lösungsskript erzeugen

makeSkriptOfType("LösungsSkript")
compileTeXFile(filename_tex, filename_pdf, filename_lsg,
               "Compile lsg file!", overwrite_old)

# ========================================================================
