# ===========================================================================
# private-Semsterdaten-ALL.R
# ==========================
#
# In dieser Datei dient zum TESTEN. Es werden die Dozentenversionen 
# OHNE Zeitplan und OHNE Ortsangaben von ALLEN Modulen erstellt.
#
# Zum Testen diese Datei als "private-Semesterdaten.R" speichern. 
# Vorher die eigne "private-Semesterdaten.R" bitte sichern!
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

semesterdaten <- tribble(
#   -------------------------------------!-------------------!-----------------!----------------------!-----------!------------!-----------
    ~Vorlesung,                           ~Ort,               ~Dozentenversion, ~Studierendenversion,  ~Zeitplan,   ~LsgSkript,  ~Schleife,
#   -------------------------------------!-------------------!-----------------!----------------------!-----------!------------!-----------
    "Wissenschaftliche-Methodik",         "",                 TRUE,             FALSE,                  FALSE,     FALSE,       TRUE,
    "Datenerhebung-Statistik",            "",                 TRUE,             FALSE,                  FALSE,     FALSE,       TRUE,
    "WissMethoden-QuantitativeDatenanalyse", "",              TRUE,             FALSE,                  FALSE,     FALSE,       TRUE,
    "Quantitative-Forschungsmethoden",    "",                 TRUE,             FALSE,                  FALSE,     FALSE,       TRUE,
    "QuantMethoden-Evaluationsforschung" , "",                TRUE,             FALSE,                  FALSE,     FALSE,       TRUE,
    "Praxis-der-Datenanalyse",            "",                 TRUE,             FALSE,                  FALSE,     FALSE,       TRUE,
    "QM-Wirtschaftsinformatik",           "",                 TRUE,             FALSE,                  FALSE,     FALSE,       TRUE
#   -------------------------------------!-------------------!-----------------!----------------------!-----------!------------!----------
)

#
# Bezeichner für das aktuelle Semester
#
semesterbezeichner <- "SoSe 2018"

# ===========================================================================