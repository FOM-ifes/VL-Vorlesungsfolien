library(wordcloud2)
library(htmlwidgets)
set.seed(1896)
themen1 <- c("Zufall", "Variation", "Modellierung", "Daten")
themen2 <- c("p-Wert", "Nullhypothese", "Alternativhypothese", "Beobachtungsstudie", "Experiment",
             "Population", "Stichprobe", "Bootstrap", "Permutationstest", "Regression", "Fehler 1. Art",
             "Fehler 2. Art", "Simulation", "Verteilung", "Anteil", 
             "Balkendiagramm", "Histogramm", "Streudiagramm", "Numerische Daten", "Kategoriale Daten",
             "Punktschätzer","Konfidenzintervall","Hypothesentest", "Mittelwert", "Varianz", "z-Wert",
             "Normalverteilung", "Teststatistik", "Validität", "Reliabilität", "Repräsentativität", "Reproduzierbarkeit",
             "Datenschutz","R", "Korrelation", "Unabhängigkeit", "Randomisierung",
             "Standardfehler")
woerter <- data.frame(words = c(themen1, themen2), freq=c(rep(2, length(themen1)),rep(0.5, length(themen2))))


wc <- wordcloud2(woerter, minRotation = -pi/4, maxRotation = pi/4)

saveWidget(wc,"tmp.html", selfcontained = FALSE)

# Anschließend über Chrome als pdf speichern
# https://stackoverflow.com/questions/42490396/how-to-put-a-wordcloud-in-a-pdf-with-a-good-quality