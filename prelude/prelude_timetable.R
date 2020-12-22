# ===========================================================================
# prelude_timetable.R (Release 0.1.3)
# ===================--------------------------------------------------------
# (W) by Norman Markgraf, Karsten Lübke & Sebastian Sauer in 2017/18
#
# 21. Feb. 2018  (nm)  Erstes Schritte. Extraktion aus der prelude.R
#                      (0.1.0)
# 23. Feb. 2018  (nm)  Tool-Routinen in eigenes prelude ausgegliedert!
#                      (0.1.1)
# 18. Mär. 2018  (nm)  Dokumentation angepasst.
#                      (0.1.2)
# 07. Feb. 2019  (nm)  Ein Studienort, mehrere Gruppen und ".Rmd" als 
#                      möglicher Ort für ein "timetable"
#                      (0.1.3)
#
#   (C)opyleft Norman Markgraf in 2017-19
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
#  Einstein’s Dictum: 
#
#     “Everything should be as simple as possible, but no simpler.”
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

select <- dplyr::select

if (!exists("prelude.tools")) {
    if (file.exists("prelude_tools.R")) {
        source("prelude_tools.R")
    } else if (file.exists("prelude/prelude_tools.R")) {
        source("prelude/prelude_tools.R")
    }
}

basePath <- file.path("..","..")
defaultSuffixe <- c(".txt", ".csv", ".xlsx")

# ---------------------------------------------------------------------------
# tab2png (based on tab2plot by Sebastian Sauer)
# ---------------------------------------------------------------------------
tab2png <- function(df, pngfile = "") {
  tt <- gridExtra::ttheme_default(
    colhead = list(
      fg_params = list(
        parse = TRUE
      )
    ),
    core = list(
      fg_params = list(
        parse = TRUE,
        hjust = 0,
        x = 0.1
      )
    )
  )

  df %>%
    dplyr::select(c("Termin", "Inhalt")) %>%
    dplyr::mutate(Inhalt = gsub("\\\\n", "\n", Inhalt)) -> df
  # ???    csv <- dplyr::select(tibble::rownames_to_column(csv), -rowname)
  #
  # Leider werden \n in csv durch \\n ersetzt. Das nehmen wir mal zurück!
  #
  tg <- gridExtra::tableGrob(df, theme = tt, rows = NULL)
  #
  # Werte 1.3 durch typ/error gefunden ... Hier muss was sinnvolles hin!
  #
  tg$widths <- grid::unit.c(
    grid::unit(1.3, "strwidth", "Sa 88.88.8888"),
    grid::unit(1.3, "strwidth", "Dimensionsreduktion, Clusteranalyse")
  )
  p <- gridExtra::arrangeGrob(tg)
  #
  # Wert 15 und 10 "cm" durch raten. Hier kann man was tun!
  #
  ggplot2::ggsave(file = pngfile, plot = p, width = 15, height = 10, units = "cm")
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
probeTimetable <- function(filename, prefix=NULL, path="Vorlesungstermine", suffixes = defaultSuffixe) {
  for (suf in suffixes) {
    tmp <- file.path(basePath, path, paste0(prefix, filename, suf))
    message(paste0("probeTimetable(): probing '", tmp, '"!'))
    if (file.exists(tmp)) {
      message(paste0("probeTimetable(): found '", tmp, '"!'))
      return(suf)
    }
  }
  msg <- paste0(
    "Es konnten keine Vorlesungtermine gefunden werden!\n",
    "Bitte erstellen Sie eine Datei `", filename, ".csv', '", filename, ".xslx' oder '", filename, "'!\n\n",
    "Es wird ohne Termine fortgesetzt.\n"
  )
  message(msg)
  return(NULL)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
checkTimetable <- function(filename, prefix=NULL, suffix=NULL, path="Vorlesungstermine") {
  fn <- file.path(basePath, path, paste0(prefix, filename, suffix))
  if (!file.exists(fn)) {
    stop(paste("FATAL ERROR: file '", fn, "' does not exist!"))
  }
  return(fn)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
checkTimetableDefault <- function(filename="default", prefix=NULL, suffix=".csv", path="Vorlesungstermine") {
  fn <- file.path(basePath, path, paste0(prefix, filename, "", suffix))
  if (!file.exists(fn)) {
    stop(paste("FATAL ERROR: file '", fn, "' does not exist!"))
  }
  return(fn)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
loadTimetableFromTxt <- function(fn, dfn) {
  library(readr)
  library(dplyr)
  df <- read_delim(fn, "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE, skip = 1)
  names(df) <- c("Tag", "Datum", "Uhrzeit", "Dozent", "Typ", "OrtImHaus", "XX", "Bemerkung", "YY")
  df %>% select(c("Tag", "Datum", "Uhrzeit")) %>% mutate(Termin = seq(along = .$Tag)) -> df
  ddf <- read_csv(dfn)
  ddf %>% mutate(Inhalt = gsub("\\\\n", "", Inhalt)) -> ddf
  df <- merge(df, ddf, by = "Termin")
  return(df)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
loadTimetableFromXlsx <- function(fn) {
  df <- readxl::read_excel(fn, col_types = c("text", "date", "text"))
  df %>%
    mutate(Datum = format(df$Datum, format = "%d.%m.%Y")) %>%
    mutate(Uhrzeit = rep(NA, length.out = nrow(.))) -> df
  df %>% select(c("Tag", "Datum", "Uhrzeit", "Inhalt")) %>% mutate(Termin = seq(along = .$Tag)) -> df
  return(df)
}


loadTimetableFromCsv <- function(fn) {
  read.csv(
      fn,
      encoding="UTF-8",
      blank.lines.skip=TRUE) %>%
    mutate(Inhalt = gsub("\\\\n", " ", Inhalt)) -> df
  return(df)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
loadTimetable <- function(filename, prefix=NULL, suffix=NULL, path="Vorlesungstermine") {
  df <- NULL
  fn <- checkTimetable(filename, prefix = prefixZeit, suffix = suffix, path = path)
  if (suffix == ".txt") {
    dfn <- checkTimetableDefault(prefix = prefixZeit, path = path)
    df <- loadTimetableFromTxt(fn, dfn)
  } else if (suffix == ".xlsx") {
    df <- loadTimetableFromXlsx(fn)
  } else if (suffix == ".csv") {
    df <- loadTimetableFromCsv(fn)
  }
  message(paste0("loadTimetable(): created data frame from file '", fn, "'!"))
  return(sortTable(df))
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
createTimetablePNG <- function(df, filename="", prefix=NULL, path="Vorlesungstermine") {
  message("createTimetablePNG(): Starting...")
  pngfile <- paste0(filename, ".png")
  pngfn <- file.path(basePath, path, pngfile)

  if (!exists("cacheVorlesungstermine")) {
    cacheVorlesungstermine <<- cacheVorlesungstermineDefault
  }

  if ((!file.exists(pngfn)) || (!cacheVorlesungstermine)) {
    tab2png(df, pngfn)
  }
  message("createTimetablePNG(): ... put into document ...")

  knitr::include_graphics(pngfn)
  return("")

  message("createTimetablePNG(): ... Ending!")
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
createTimetableKable <- function(df=NULL) {
  ret <- "XXX"
  message("createTimetableKable(): Starting...")
  if (is.null(df)) {
    message("createTimetableKable(): df is NULL!")
  } else {
    ret <- knitr::kable(as.data.frame(df), format = "latex")
  }
  message("createTimetableKable(): ... Ending!")
  return(ret)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
createTimetableXtable <- function(df) {
  message("createTimetableXtable(): Starting...")
  library(xtable)
  if (all(is.na(df$Uhrzeit))) {
    df %>% select(-Uhrzeit) -> df
  }
  #  rownames(df) <- NULL
  xtab <- xtable(df)
  n <- ncol(df) - 2
  tmp <- "rc"
  for (i in seq(1, n)) {
    tmp <- paste0(tmp, "l")
  }
  align(xtab) <- paste0(tmp, "p{8cm}")
  #    ret <- knitr::asis_output(tyxtable(print(xtab, booktab = TRUE)), cacheable = FALSE)
  ret <- tyxtable(print(xtab, booktab = TRUE, comment = FALSE, type = "latex", include.rownames = FALSE), trim = 0)
  message(ret)
  message("createTimetableXtable(): ... Ending!")
  return(ret)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sortTable <- function(df) {
  df.colname <- names(df)
  
  if (!("Tag" %in% df.colname)){
      df$Tag <- rep("", length(df$Inhalt))
  }
  if (!("Datum" %in% df.colname)){
      df$Datum <- rep("", length(df$Inhalt))
  }
  if (!("Uhrzeit" %in% df.colname)){
      df$Uhrzeit <- rep("", length(df$Inhalt))
  }
  df %>% select("Tag", "Datum", "Uhrzeit", "Inhalt") -> df
  return(as.data.frame(df))
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

filenameRmdTimetable <- function(ttname = "", path ="Vorlesungstermine") {
    file.path(basePath, path, paste0(prefixZeit, ttname, ".Rmd"))
}

existsRmdTimetable <- function(ttname = "") {
    fn <- filenameRmdTimetable(ttname)
    file.exists(fn)
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

makeTimetable <- function(ttname = "", tttype = "xtable") {
  suffix <- probeTimetable(ttname, prefix = prefixZeit)
  if (is.null(suffix)) {
    return()
  }
  ret <- "XXX"
  df <- loadTimetable(ttname, prefix = prefixZeit, suffix = suffix)
  if (tttype == "png") {
    ret <- createTimetablePNG(df, ttname, prefix)
  } else if (tttype %in% c("knitr", "kable", "kntir::kable")) {
    ret <- createTimetableKable(df)
  } else if (tttype == "xtable") {
    ret <- createTimetableXtable(df)
  } else {
    message("makeTimetable(): ERROR: No propper timetabletype found!")
  }
}

# ===========================================================================