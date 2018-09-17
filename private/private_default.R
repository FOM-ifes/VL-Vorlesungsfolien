# ===========================================================================
# private.R
# =========
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# DozentInnen Information
DozInfo <- list(
  Titel = "Dipl.-Math.",       # "Prof. Dr.", "Dr.", ""
  Vorname = "Norman",          # "Karla Antonia Sybilla"
  Nachname = "Markgraf" ,      # "Säuereich-Weinnie"
  Geschlecht = "m",            # "m" männlich, "w" weiblich und "d" drittes Geschlecht
  Email = "nmarkgraf@hotmail.com", 
  WebURL = "http://www.sefiroth.de",
  Avatar = NULL,
  Telegram = "",
  WhatsApp = "",
  Skype = ""
)

# Soll eine Seite mit ihren Datein (private-Vorstellung.Rmd) in das Skript?
privateVorstellung <<- FALSE
# Soll ein Terminplan in das Skript?
showVorlesungsplan <<- FALSE
# Einstellung für die Log-Datei (DEBUG/INFO/WARNING/ERROR)
defaultThreshold <<- ERROR
# Soll useR Umfrage ind Analyse angezeigt werden?
useR <<- TRUE

# ===========================================================================