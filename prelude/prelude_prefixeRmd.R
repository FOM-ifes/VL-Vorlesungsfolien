# ===========================================================================
# prelude_prefixeRmd.R (Release 0.1.1)
# ====================-------------------------------------------------------
# (W) by Norman Markgraf in 2018
#
# 15. Mär. 2018  (nm)  Erstes Schritte 
#                      (0.1.0)
# 18. Mär. 2018  (nm)  Dokumentation angepasst.
#                      (0.1.1)
#
#   (C)opyleft Norman Markgraf in 2018
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
# "Der Begriff Qualität in der Programmierung steckt noch 
#  in den Anfängen." 
#
#                                                           -- Wau Holland
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

if (!exists("prelude.prefixeRmd")) {
  prelude.prefixeRmd <<- "LOADED!"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  prefixeRmd <- list()
  prefixeRmd <- c("DES", "PraDa", "QFM", "QMEval", "QMWI", "WM", "WMQD")
  prefixeRmdNames <- c("Datenerhebung-Statistik", "Praxis-der-Datenanalyse", 
                       "Quantitative-Forschungsmethoden", "QuantMethoden-Evaluationsforschung", 
                       "QM-Wirtschaftsinformatik", "Wissenschaftliche-Methodik",
                       "WissMethoden-QuantitativeDatenanalyse")
  names(prefixeRmd) <- prefixeRmdNames
}

# ===========================================================================