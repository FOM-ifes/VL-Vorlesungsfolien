# ------------------------------------------------------------------------
# makerender.R                              Version 1.6.6 - 23. Feb. 2022 
# ============------------------------------------------------------------
#
# (C) by N. Markgraf & M. Gehrke in 2019-2021
# (C) by N. Markgraf, T. Griesenbeck & M. Gehrke since 2022
#
# Kleines R-Skript zum erstellen von Dozenten- / Studierenden- und
# Lösungsskript aus einer R markdown Datei ohne dass mehrfach geknitert 
# werden muss.
#
# Aufruf für ein Rmarkdown als R Skript:
# Rscript --vanilla makerender.R Wissenschaftliche-Methodik
#
# Idee: Matthias Gehrke 
#
# ------------------------------------------------------------------------
library(optparse)  # Kommandozeilen Parser
library(yaml)  # YAML Parser und Writer

# -- Standardeinstellungen definieren  -----------------------------------
DEBUG <- FALSE  # Debug-Meldungen ausgeben
DEBUG_source <- FALSE  # TRUE erzeugt eine Kommandozeile für Debug im Debugger
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
# Private Vorstellung mit einbauen? via Inhalte/private/private-Vorstellung.Rmd
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
ShowPrivate <- FALSE  # 
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
# Benutze die Informationen aus der Datei Inhalte/private/private.R?
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
UsePrivate <- TRUE  # 
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
# Erstelle Vorlesungsplan aus der Datei Vorlesungstermine/xx-default.Rmd
showVorlesungsplan <- FALSE
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
# Angabe des Semesters. 
# Sommersemester: "SoSe 20XX"
# Wintersemesrer: "WiSe 20XX/XX"
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
#Semester <- "WiSe 2021/22"  # Standard Semesterangabe (SoSe XXXX / WiSe XXXX/XX)
Semester <- "SoSe 2023"  # Standard Semesterangabe (SoSe XXXX / WiSe XXXX/XX)
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
# Angabe der/des Lehrenden. Standard ist "FOM Dozent:in"
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
Dozent <- "FOM Dozent:in"  # Standard Dozent:innenangabe
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
# Angabe des Studienortes. Standard ist "FOM"
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
Studienort <- ""  # Standard Studienort
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
# Mit welchem LaTeX Programm soll übersetzt werden?
# Seit Januar 2022 ist xelatex die Standardmethode! Vorher war es pdflatex
# Möglich sind daher: "xelatex", "lualatex" und "pdflatex"
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
latex_engine <- "xelatex"
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
# Anhängsel an den Dateinamen, falls benötigt. Hiermit sollte eigentlich#
# die Möglichkeit bestehen für verschiedene Standorte Skripte zu erstellen
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
midfix <- ""
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
# Angabe des Skriptes, welches übersetzt werden soll,
# falls keines direkt angegeben wurde.
# Dabei handelt es sich um den Dateinamen ohne die Endung ".Rmd".
#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - -  - - - - - - -
defaultFilename <- "Wissenschaftliche-Methodik"
# ------------------------------------------------------------------------

# Kopie von "_output.yaml" anlegene:
outputyamlbak <- tempfile(pattern = "_output-",tmpdir = ".", fileext = ".yaml")
overwrite_old <- TRUE
tmp_layouttype <- ""


# Zur Sicherheit starten wir mal 'reticulte'. Damit sollte die korrekte
# Python Version benutzt werden!
suppressWarnings({
    if (any(is.na(packageDescription("reticulate")))) { 
        install.package("reticulate")
    }
    out <- capture.output(reticulate::py_config())
    
    if (any(is.na(packageDescription("futile.logger")))) {
        install.packages("futile.logger")
    }
})


# ========================================================================
# Unterroutinen
# ------------------------------------------------------------------------
SetupArgumentParser <- function() {
    parser <- OptionParser(
        description = "(C) in 2019-2022 by N. Markgraf, T. Griesenbeck & M. Gehrke"
    )
    # Variable: verbose
    parser <- add_option(parser, 
                         c("-v", "--verbose"), 
                         action = "store_true",
                         default = FALSE,
                         help = "Erweiterte Ausgabe von Laufzeitinformtionen"
    )
    # Variable: clean
    parser <- add_option(parser, 
                         c("-c", "--clean"), 
                         action = "store_true",
                         help = "Zu Beginn alle temporären Dateien löschen")
    # Variable: dls
    parser <- add_option(parser, 
                         c("-d", "--dls"), 
                         action = "store_true",
                         help = "Erzeugen eines DLS Skripts")
    # Variable: semester
    parser <- add_option(parser, 
                         c("-s", "--semester"),
                         action = "store",
                         type = "character",
                         dest = "semester",
                         help = "Semesterangabe einstellen")
    # Variable: studienort
    parser <- add_option(parser, 
                         c("-o", "--studienort"),
                         action = "store",
                         type = "character",
                         dest = "studienort",
                         help = "Studienort einstellen")
    # Variable: dozent  
    parser <- add_option(parser, 
                         c("-l", "--lecturer"),
                         action = "store",
                         type = "character",
                         dest = "dozent",
                         help = "Vortragende:n einstellen")
    parser <- add_option(parser, 
                         c("-a", "--author"),
                         action = "store",
                         type = "character",
                         dest = "dozent",
                         help = "Vortragende:n einstellen")
    # Variable: latex-engine
    parser <- add_option(parser, 
                         c("-e", "--latex-engine"),
                         action = "store",
                         type = "character",
                         default = "xelatex",
                         dest = "latexengine",
                         help = "LaTeX engine [xelatex/pdflatex/lualatex]")
    # Variable: Layout
    parser <- add_option(parser, 
                         c("--layout"),
                         action = "store",
                         default = "FOM",
                         dest = "Layout",
                         help = "Layout [FOM/eufom]")
    # Variable: midfix
    parser <- add_option(parser, 
                         c("-m","--midfix"),
                         action = "store",
                         default = "",
                         dest = "midfix",
                         help = "Wird zwischen dem Dateinamen und der Endung eingefügt.")
    # Variable: showprivate
    parser <- add_option(parser, 
                         c("-p", "--showprivate"),
                         action = "store_true",
                         dest = "showprivate",
                         help = "Soll eine 'Private Vorstellung' eingebaut werden?")
    # Variable: nostudi
    parser <- add_option(parser, 
                         c("--nostudi"), 
                         action = "store_true",
                         default = FALSE,
                         help = "Studierendenskript nicht erstellen."
    )
    # Variable: nolsg
    parser <- add_option(parser, 
                         c("--nolsg"), 
                         action = "store_true",
                         default = FALSE,
                         help = "Lösungsskript nicht erstellen."
    )
    
    parser
}
# ------------------------------------------------------------------------
# Lokale Funktion, welche die externen Dateien anpasst:
compileTeXFile <- function(texfile, pdffilesource, pdffiledest, 
                           msg = "", engine = "xelatex", ovrwrt = TRUE) {
    if (DEBUG) cat(paste0(msg,"\n"))
    options(tinytex.latexmk.warning = FALSE)
    options(tinytex.compile.min_times = 2)
    options(tinytex.compile.max_times = 5)
    tinytex::latexmk(texfile, engine = engine)
    if (DEBUG) cat(paste("copy", pdffilesource, "to", pdffiledest, "..."))
    file.copy(pdffilesource, pdffiledest, overwrite = ovrwrt)
    if (DEBUG) cat("..done!")
}
# ------------------------------------------------------------------------
# Löschen aller temporären Dateien in Abhängigkeit von "filename"
cleanTemporaryFiles <- function(filename) {
    if (length(filename) < 1) return()
    
    if (DEBUG)print("Do cleaning ...")
    # Liste der Endungen von temporären Dateien:
    suffixes <- c(
        ".tex",
        ".log",
        ".md",
        ".utf8.md",
        ".knit.md",
        ".html",
        ".toc",
        ".snm",
        ".nav",
        ".aux",
        ".vrb",
        ".synctex.gz"
    )
    for (suf in suffixes) {
        filelist <- dir(".", paste0(filename, suf))
        for (cur.file in filelist) {
            if (file.exists(cur.file)) {
                if (DEBUG) print(paste("remove file", cur.file))
                file.remove(cur.file)
            }
        }
    }
}
# ------------------------------------------------------------------------
initOutputYaml <- function(doBackUp = TRUE) {
    if (doBackUp) {
        file.copy("_output.yaml", outputyamlbak)
    }
    read_yaml("_output.yaml")
}
writeOutputYaml <- function(outputyaml) {
    write_yaml(outputyaml, "_output.yaml")
}

finishOutputYaml <- function(doBackUp = TRUE) {
    if (doBackUp) {
        file.remove("_output.yaml")
        file.copy(outputyamlbak, "_output.yaml")
        file.remove(outputyamlbak)
    }
}

# ========================================================================
# Hauptroutine
# ========================================================================

# -- Einrichten des Kommandozeile Parsers  --------------------------------
parser <- SetupArgumentParser()  # Commandline Parser einrichten

# -- Auswerten der Kommandozeile -----------------------------------------
if (DEBUG_source) {  # 
    parsedArguments <- parse_args(
        parser, 
        args = c(
            '-vc', 
            '--semester="SoSe 2022"', 
            '--studienort="Gütersloh"', 
            '--lecturer="Prof. Dr. Heinz Holling"', 
            "Datenerhebung-Statistik"), 
        positional_arguments = TRUE)
} else {
    parsedArguments <- parse_args(parser, positional_arguments = TRUE)
}
if (DEBUG) {
    print(parsedArguments)
}

# Rmd-Script festlegen
if (exists("parsedArguments") && (hasName(parsedArguments, "args")) && (length(parsedArguments$args) > 0)) {
    filename <- parsedArguments$args[1]
} else {
    filename <- defaultFilename 
}

# Sollte 'clean' gewählt sein, dann temporäre Dateien löschen
if (exists("parsedArguments") && hasName(parsedArguments,"options")) {
  if (hasName(parsedArguments$options, "clean") && parsedArguments$options$clean) {
      cleanTemporaryFiles(filename)
  }
  outputyaml <- initOutputYaml()
  # Ggf die LaTeX-Engine anpassen
  if (exists("parsedArguments") && hasName(parsedArguments,"latexengine")) {
    latexengine <- parsedArguments$options$latexengine
    if (latexengine %in% c("pdflatex", "xelatex", "lualatex")) {
      latex_engine <- latexengine
      outputyaml$beamer_presentation$latex_engine <- latex_engine
    }
  }
  if (hasName(parsedArguments$options,"dls") && parsedArguments$options$dls) {
    outputyaml$beamer_presentation$pandoc_args <- c(
      outputyaml$beamer_presentation$pandoc_args,
      "-V", "themeoptions=DLS"
    )
  }
  if (hasName(parsedArguments$options, "midfix")) {
      midfix <- parsedArguments$options$midfix
  }
  if (hasName(parsedArguments$options, "Layout")) {
    tmpLayout <- parsedArguments$options$Layout
    if (hasName(parsedArguments$options,"dls") && parsedArguments$options$dls) {
      tmpLayoutYaml <- "FOM-DLS"
      tmp_layouttype <- "DLS"
    } else {
      if (tolower(tmpLayout) %in% c("fom", "eufom")) {
        if (tolower(tmpLayout) == "eufom") {
          tmpLayoutYaml <- "EUFOM"
          tmp_layouttype <- "eufom"
          
        } else {
          tmpLayoutYaml <- "FOM"
          tmp_layouttype <- "FOM"
        }
      }
    }
    if (DEBUG) print("**** modify inner-/outertheme")
    i <- charmatch("outertheme=NPBT-", outputyaml$beamer_presentation$pandoc_args)
    outputyaml$beamer_presentation$pandoc_args[i] <- paste0("outertheme=NPBT-", tmpLayoutYaml)
    i <- charmatch("colortheme=NPBT-", outputyaml$beamer_presentation$pandoc_args)
    outputyaml$beamer_presentation$pandoc_args[i] <- paste0("colortheme=NPBT-", tmpLayoutYaml)
  }
  writeOutputYaml(outputyaml)
  write_yaml(outputyaml, stdout())
  if (hasName(parsedArguments$options, "semester")) {
      Semester <- parsedArguments$options$semester
  }
  if (hasName(parsedArguments$options, "studienort")) {
      Studienort <- parsedArguments$options$studienort
  }
  if (hasName(parsedArguments$options, "dozent")) {
      Dozent <- parsedArguments$options$dozent
      UsePrivate <- FALSE
  } 
  if (hasName(parsedArguments$options, "showprivate")) {
      ShowPrivate <- parsedArguments$options$showprivate
  } 
}

# ------------------------------------------------------------------------

print("======================================================================")

cat(paste0("** makerender.R übersetzt ", filename,".Rmd\n\n\n"))

# ------------------------------------------------------------------------
source("prelude.R")

# ------------------------------------------------------------------------
# Hiermit werden die Einstellungen im Rmd-Skript übersprungen:

RENDEREDBYSCRIPT <<- TRUE

# ------------------------------------------------------------------------
# Die wichtigesten Prelude-Skripte schon einmal laden: 
source("prelude/prelude_tools.R")
source("prelude/prelude_rendertools.R")

# ------------------------------------------------------------------------
# Die im Skript übersprungenen Einstellungen müssen nun nachgeholt werden:

assign("abschluss", TRUE, envir = .GlobalEnv)
assign("WDH", "", envir = .GlobalEnv)

# ------------------------------------------------------------------------
# 
my.options$set(
    Corona = FALSE
)
my.options$set(
  privateVorstellung = ShowPrivate,   # Zeige die Private Vorstellung
  showVorlesungsplan = showVorlesungsplan,  # Zeige den Vorlesungsplan
  showuseR = FALSE,
  Corona = FALSE,
  MasterNeu = TRUE,            # Überarbeitung Master mg, kl
  use_private = UsePrivate
)
if (tmp_layouttype != "") {
    my.options$set(
        layouttype = tmp_layouttype
    )
}

assign("UseCache", FALSE, envir = .GlobalEnv)  # immer mal wieder auf FALSE setzen
ifelse(showVorlesungsplan, assign("Vorlesungstermine", "default", envir = .GlobalEnv), assign("Vorlesungstermine", "", envir = .GlobalEnv))


if (!my.options$get("use_private")) {
  my.options$set(privateVorstellung = FALSE)   # Zeige die Private Vorstellung
}

# Default Werte für "private.yaml":
if (my.options$get("use_private") && file.exists("private/private.R")) {
  source("private/private.R")
  createPrivateYaml(DozInfo, Semester, "FOM", Studienort)
} else {
#  createPrivateYaml("Prof. H. Holling & Dipl.Math. N. Markgraf", Semester, "FOM", Studienort)
  createPrivateYaml(Dozent, Semester, "FOM", Studienort)
}

# ------------------------------------------------------------------------
# Aus dem angegebenen Dateinamen werden einige abgeleitete 
# Dateinamen erzeugt:

filename_rmd <- paste0(filename, ".Rmd")
filename_tex <- paste0(filename, ".tex")
filename_pdf <- paste0(filename, ".pdf")
filename_warn <- paste0(filename, "-warnings.log")

filename_dozi <- paste0(filename, midfix, "-Dozifassung.pdf")
filename_studi <- paste0(filename, midfix, "-Studifassung.pdf")
filename_lsg <- paste0(filename, midfix, "-Lsg.pdf")


# ------------------------------------------------------------------------
### HAUPTROUTINE ###
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
# Dozentenskript erzeugen

makeSkriptOfType("DozentenSkript") 

cat("Render and compile dozi file!\n")

save.image(file = "all.rda")

rmarkdown::render(
    input = filename_rmd,
    encoding = "UTF-8",
    clean = FALSE
  )

load("all.rda", .GlobalEnv)

finishOutputYaml()

if (exists("parsedArguments") && hasName(parsedArguments,"options")) {
    if (hasName(parsedArguments$options, "verbose")) {
        print(parsedArguments$options$verbose)
        if (parsedArguments$options$verbose) {
            cat(summary(warnings()), file = filename_warn)
        }
    }
}
if (DEBUG) cat(paste("copy", filename_pdf, "to", filename_dozi, "..."))
file.copy(filename_pdf, filename_dozi, overwrite = overwrite_old)
if (DEBUG) cat("..done!")


# ------------------------------------------------------------------------
# Studierendenskript erzeugen
makeStudiskript <- function(filename_tex, filename_pdf, filename_lsg, 
         latex_engine, overwrite_old) {
    makeSkriptOfType("StudierendenSkript") 
    compileTeXFile(filename_tex, filename_pdf, filename_studi, 
                   "Compile studi file!", latex_engine, overwrite_old)
}

if (exists("parsedArguments") && hasName(parsedArguments,"options")) {
    if (hasName(parsedArguments$options, "nostudi") && parsedArguments$options$nostudi) {
        cat(paste("Kein Studierendenskript erzeugen!\n"))
    } else {
        makeStudiskript(filename_tex, filename_pdf, filename_lsg,
                        latex_engine, overwrite_old)
    }
} else {
    makeStudiskript(filename_tex, filename_pdf, filename_lsg,
                    latex_engine, overwrite_old)
}
# ------------------------------------------------------------------------
# Lösungsskript erzeugen

makeLoesungsskript <- function(filename_tex, filename_pdf, filename_lsg, 
                               latex_engine, overwrite_old) {
    makeSkriptOfType("LösungsSkript") 
    compileTeXFile(filename_tex, filename_pdf, filename_lsg, 
                   "Compile lsg file!", latex_engine, overwrite_old)
}

if (exists("parsedArguments") && hasName(parsedArguments,"options")) {
    if (hasName(parsedArguments$options, "nolsg") && parsedArguments$options$nolsg) {
        cat(paste("Kein Lösungsskript erzeugen!\n"))
    } else {
        makeLoesungsskript(filename_tex, filename_pdf, filename_lsg,
                           latex_engine, overwrite_old)
    }
} else {
    makeLoesungsskript(filename_tex, filename_pdf, filename_lsg,
                       latex_engine, overwrite_old)
}

# ========================================================================