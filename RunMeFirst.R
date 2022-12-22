# ===========================================================================
# RunMeFirst.R (Release 1.1)
# =============--------------------------------------------------------------
# (W) by Norman Markgraf in 2018
#
# 28. Nov. 2018  (nm)  Erstes Release (1.0)
# 28. dec. 2018  (nm)  Das Pandoc-Filter Update Script laufen lassen (1.1)
#
#
# Dieses R-Skript sollten Sie bei einer ersten Installation unseres 
# Frameworks mit Hilfe des Befehls `source("RunMeFirst.R")`
# starten. Es prüft ob alle Pakete geladen sind und läd diese ggf. nach oder 
# aktualisiert diese.
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
#
#
# "Als es noch keine Computer gab, war das Programmieren noch 
#  relativ einfach." 
#
#                                                      -- Edsger W. Dijkstra
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

bootstrap_install_packages <- function(packages) {
    if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
        install.packages(setdiff(packages, rownames(installed.packages())))  
    } 
}

bootstrap_packages <- c("futile.logger", "mosaic")

bootstrap_install_packages(bootstrap_packages)

source("prelude/prelude_tools.R")
source("prelude/prelude_packages.R")
df <- read.csv("prelude/prelude.csv")

checkPackages(df)

rm(list = ls())

# pandoc filter laden:
source("updatePythonScripts.R")

# .rs.restartR()

# ===========================================================================
