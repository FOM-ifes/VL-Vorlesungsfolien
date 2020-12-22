#
# clean-up.R
#

propper <- FALSE

basedir <- file.path(".")

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

suffixes.propper <- c(
    ".pdf",
    "-Dozifassung.pdf",
    "-Lsg.pdf",
    "-Studifassung.pdf"
)

suffixes.dir <- c(
    "_files",
    "_cache"
)

scripts <- c(
    "Wissenschaftliche-Methodik",
    "DES-Anhang",
    "NextGen",
    "BlubberZisch",
    "Datenerhebung-Statistik",
    "Etwas-R-am-Abend",
    "Masterskript",
    "MathGrundlDWInfo",
    "OperationsResearch",
    "Praxis-der-Datenanalyse",
    "QM-Wirtschaftsinformatik",
    "QuantMethonden-Evaluationsforschung",
    "Marketing-Controlling",
    "WissMethoden-QuantitativeDatenanalyse",
    "QM-MathematikStatistik-Statistik",
    "Unternehmenskommunikation"
)


filenames <- c(
    scripts,
    "include_exclude",
    "style",
    "typography",
    "missfont",
    "watermark"
)

if (propper) {
    suffixes <- c(suffixes, suffixes.propper)
}

for(filename in filenames) {
    for (suffix in suffixes){
        cur.file <- paste0(filename, suffix)
        if (file.exists(cur.file)) {
            file.remove(cur.file)
        }
    }
}

for(filename in scripts) {
    for (suffix in suffixes.dir) {
        cur.dir <- paste0(filename, suffix)
        if (dir.exists(cur.dir)) {
            unlink(cur.dir, recursive = TRUE)
        }
    }
}
