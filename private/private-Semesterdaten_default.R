# ===========================================================================
# private-Semsterdaten_default.R
# ==============================
#
# In dieser Datei können Sie Ihre persönlichen Semsterdaten an.
# Vorlesungen, Orte und ob Sie eine Dozentenversion und/oder 
# Studierendenversion haben wollen.
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

semesterdaten <- tribble(
#   -------------------------------------!-------------------!-----------------!----------------------!-----------!------------
    ~Vorlesung,                           ~Ort,               ~Dozentenversion, ~Studierendenversion,  ~Zeitplan,  ~LsgSkript,
#   -------------------------------------!-------------------!-----------------!----------------------!-----------!------------
    "Wissenschaftliche-Methodik",         "Düsseldorf",       TRUE,             TRUE,                  TRUE,        TRUE,
    "Datenerhebung-Statistik",            "Düsseldorf",       TRUE,             TRUE,                  TRUE,        TRUE,
    "Datenerhebung-Statistik",            "Wuppertal",        TRUE,             TRUE,                  TRUE,        TRUE,
    "QM-Wirtschaftsinformatik",           "Münster",          TRUE,             TRUE,                  FALSE,       TRUE
#   -------------------------------------!-------------------!-----------------!----------------------!-----------!------------
)

#
# Bezeichner für das aktuelle Semester
#
semesterbezeichner <- "SoSe 2018"

# ===========================================================================