**Wiki zu den Vorlesungsunterlagen:** [https://github.com/luebby/Vorlesungen/wiki/Lehre-als-Sammlung-von-Tricks](https://github.com/luebby/Vorlesungen/wiki/Lehre-als-Sammlung-von-Tricks)

Fehler etc. bitte unter [https://github.com/luebby/Vorlesungen/issues](https://github.com/luebby/Vorlesungen/issues) melden!


## Notwendige Software

- möglichst aktuelles R, RStudio, LaTeX
- LaTeX u. a. Paket `beamer`, `cm-super`, `ulem`
- pandoc in der aktuellen Version (2.0.3) -- RStudio liefert gegenwärtig nur 1.19.2.1 mit: [https://github.com/jgm/pandoc/releases/tag/2.0.3](https://github.com/jgm/pandoc/releases/tag/2.0.3). 
- rmarkdown in der aktuellen Version (1.8 oder später).
- Python3 mit panflute: [https://www.python.org/downloads/](https://www.python.org/downloads/). Nach der Installation über die Windows Eingabeaufforderung (Terminal) panflute installieren: `pip3 install panflute`.
- **Wichtig für Windows 10+ Nutzer:** Python muss richtig installiert werden: [https://www.howtogeek.com/197947/how-to-install-python-on-windows/](https://www.howtogeek.com/197947/how-to-install-python-on-windows/) Hierbei immer über der den Installer gehen (s. Installationsanleitung) und "Add Python 3.6 to PATH" beim ersten Installationsheinweis anklicken. Dann Computer neu starten und den Befehl (pip3 install panflute) in die Kommandozeile (unter dem Reiter "Terminal") eingeben.

Hinweise zur Benutzung von GitHub: [http://happygitwithr.com/](http://happygitwithr.com/)

Hinweise zu RStudio, R und R Markdown: [https://ismayc.github.io/rbasics-book/](https://ismayc.github.io/rbasics-book/)

## Erste Schritte


Um eine Rohfassung der Skripte zu erzeugen, die entsprechnde Rmd Datei mit dem jeweiligen Vorlesungsnamen in RStudio öffnen und knitrn.
Besser ist aber, sie passen erst die Daten im Verzeichnis `private/` an und nutzen das Skript `MakeMySemester.R` zum erzeugen.

*Tipps*: 

- Evt. muss zweimal geknittet werden, damit die Übungsnummerierung passt.
- Gelegentlich den Knitr Cache leeren.
- Vorsicht bei Netzlaufwerken (OneDrive etc.): hier kann es zu Schreib-/Leseproblemen kommen 

## Wo muss/kann ich etwas anpassen?

**Kontrollieren Sie die Prüfungsleistungen!** Diese sind in der Datei `Inhalte/Orga-xxx.Rmd`, wobei `xxx` für die Vorlesungen (*DES*, *QuantFor*, *WissMeth*, *WM-Quant* , *PraDa*) steht.

Es gibt zwei Stellen, an denen Sie vor dem (ersten) Erstellen der Skripte Hand anlegen sollten:

1. Erstellen einer `private/private.R` Datei

Als Vorlage können Sie die Datei `private/private_default.R` nutzen. Kopieren Sie dazu die Datei `private/private_default.R` 

```
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
privateVorstellung <<- TRUE

# ===========================================================================
```
einfach in Ihre Datei `private/private.R` und passen Sie die entsprechenden Felder an. 
Z.B.:

```
# ===========================================================================
# private.R
# =========
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# DozentInnen Information
DozInfo <- list(
  Titel = "Prof. Dr.",       # "Prof. Dr.", "Dr.", ""
  Vorname = "Bianca",          # "Karla Antonia Sybilla"
  Nachname = "Krol" ,      # "Säuereich-Weinnie"
  Geschlecht = "w",            # "m" männlich, "w" weiblich und "d" drittes Geschlecht
  Email = "bianca.krol@fom.de", 
  WebURL = "http://www.fom.de",
  Avatar = NULL,
  Telegram = "",
  WhatsApp = "",
  Skype = ""
)

# Soll eine Seite mit ihren Datein (private-Vorstellung.Rmd) in das Skript?
privateVorstellung <<- TRUE

# ===========================================================================
```

Falls Sie zwar eine personalisierte Fassung erzeugen wollen, aber keine Vorstellungsseite, dann ändern Sie bitte die Zeile `privateVorstellung` in

```

# Soll eine Seite mit ihren Datein (private-Vorstellung.Rmd) in das Skript?
privateVorstellung <<- FALSE

```

ab. Möchten Sie keine personalisierte Fassung erstellen, sondern eine *Modulfassung*, so können Sie das mit

```
# ===========================================================================
# private.R
# =========
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# DozentInnen Information
DozInfo <- NULL

# Soll eine Seite mit ihren Datein (private-Vorstellung.Rmd) in das Skript?
privateVorstellung <<- FALSE

# ===========================================================================
```

erreichen.

2. Erstellen einer `private/private-Semesterdaten.R` Datei

In der Datei `private/private-Semesterdaten.R` können die Vorlesungen festlegen, die sie aktuell erstellen möchten.

Dazu kopieren Sie einfach die Vorlage `private/private-Semesterdaten_dafault.R` in die Datei `private/private-Semesterdaten.R` un passen diese an Ihre Bedürfnisse an:

```
# ===========================================================================
# private-Semsterdaten.R
# ======================
#
# In dieser Datei können Sie Ihre persönlichen Semsterdaten an.
# Vorlesungen, Orte und ob Sie eine Dozentenversion und/oder 
# Studierendenversion haben wollen.
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

semesterdaten <- tribble(
#   -------------------------------------!-------------------!-----------------!----------------------!----------
    ~Vorlesung,                           ~Ort,               ~Dozentenversion, ~Studierendenversion,  ~Zeitplan,
#   -------------------------------------!-------------------!-----------------!----------------------!----------
    "Wissenschaftliche-Methodik",         "Düsseldorf",       TRUE,             TRUE,                  TRUE,
    "Datenerhebung-Statistik",            "Düsseldorf",       TRUE,             TRUE,                  TRUE,
    "Datenerhebung-Statistik",            "Wuppertal",        TRUE,             TRUE,                  TRUE,
    "QM-Wirtschaftsinformatik",           "Münster",          TRUE,             TRUE,                  FALSE
#   -------------------------------------!-------------------!-----------------!----------------------!----------
)

#
# Bezeichner für das aktuelle Semester
#
semesterbezeichner <- "WiSe 2018/19"

# ===========================================================================
```
Unter *Vorlesung* tragen Sie bitte den Dateinamen der entsprechenden Vorlesung **ohne** die Endung ".Rmd" ein. 
Aus dem Ort wird (unter Umwandlung der Umlaute in "ae", "oe", "ue") später die Terminvorschläge erzeugt.

Dozentenversionen enthalten die Musterlösungen, Studierendenversionen enthalten diese nicht.


3. Termine eintragen

Tragen Sie für Ihre Veranstaltung (*DES*, *QFM*, *WMQD*, *WM* , *PraDA*, *WMWinf*, *QMEval-*) und Ihren Standort Ihre Termine ein (Ordner: `Vorlesungstermine`. Z. B. für Wissenschaftliche Methodik in Dortmund: `WM-Dortmund.csv`.) 

*Achtung:* die csv Datei ist kommagetrennt. Evt. auf Encoding (Umlaute) beachten.

Eine solche Datei würde dann wie folgt aussehen: (Hier als Beispiel die Datei `DES-Muenchen.csv`)

```
"Tag", "Datum", "Uhrzeit", "Inhalt"
"1","01.01.1980","","Ein weiterer Vorlesungstermin folgt"
"2","12.03.2018","","Organisatorisches & Wissenschaftliche Grundlagen"
"3","20.03.2018","","Einfuehrung in R"
"4","26.03.2018","","Explorative Datenanalyse"
"5","26.03.2018","","Einfuehrung Inferenz"
"6","09.04.2018","","Inferenz kategorialer Daten"
"7","17.04.2018","","Inferenz numerischer Daten"
"8","24.04.2018","","Wiederholung der Inferenzstatistik"
"9","08.05.2018","","Lineare Regression"
"10","15.05.2018","","Datenhandling"
"11","22.05.2018","","Fallstudie zur praktischen Datenanalyse"
"12","28.05.2018","","Fachartikel lesen"
"13","29.05.2018","","Coaching zur Datenanalyse"
"14","04.06.2018","","Wiederholung"
"15","11.06.2018","","Klausur"
```

Möchten Sie unter `Uhrzeit` noch die genauen Uhrzeiten eintragen, so können Sie das machen.


## Literatur

- Motivation: Cobb GW (2007). The introductory statistics course: a Ptolemaic curriculum?, Technology Innovations in Statistics Education, 1(1): [http://escholarship.org/uc/item/6hb3k0nz](http://escholarship.org/uc/item/6hb3k0nz)
- Theorie: Hesterberg, TC (2014). What Teachers Should Know about the Bootstrap: Resampling in the Undergraduate Statistics Curriculum: [https://arxiv.org/abs/1411.5279](https://arxiv.org/abs/1411.5279)
- Theorie: Ernst, MD (2004).  Permutation methods:  A Basis for Exact Inference, Statistical Science, 19, 676-685. [https://projecteuclid.org/euclid.ss/1113832732](https://projecteuclid.org/euclid.ss/1113832732)
- `mosaic`: Pruim R, Kaplan DT und Horton NJ (2017). The mosaic Package: Helping Students to ‘Think with Data’ Using R. The R Journal, 9(1), 77-10:[https://journal.r-project.org/archive/2017/RJ-2017-024/index.html](https://journal.r-project.org/archive/2017/RJ-2017-024/index.html). 
- Quizze: McGowan HM, Gunderson, BK (2010). Randomized Experiment Exploring How Certain Features of Clicker Use Effect
Undergraduate Students' Engagement and Learning in Statistics. Technology Innovations in Statistics Education, 4(1): [https://escholarship.org/uc/item/2503w2np](https://escholarship.org/uc/item/2503w2np)
- Cartoons etc.: Lesser LM, Pearl DK, & Weber, JJ (2016). Assessing fun items’ effectiveness in increasing learning of college introductory statistics students: Results of a randomized experiment. Journal of Statistics Education, 24(2), 54-62. [http://tandfonline.com/doi/pdf/10.1080/10691898.2016.1190190](http://tandfonline.com/doi/pdf/10.1080/10691898.2016.1190190)
- GAISE Empfehlungen: [http://www.amstat.org/asa/files/pdfs/GAISE/GaiseCollege_Full.pdf](http://www.amstat.org/asa/files/pdfs/GAISE/GaiseCollege_Full.pdf)
- Lehre allgemein: Lang JM (2016). Small Teaching. [http://www.jamesmlang.com/p/small-teaching.html](http://www.jamesmlang.com/p/small-teaching.html)

## Lizenz

- Diese Folien wurde von Karsten Lübke von der FOM [https://www.fom.de/](https://www.fom.de/) entwickelt und stehen unter der Lizenz CC-BY-SA-NC 3.0 de: [https://creativecommons.org/licenses/by-nc-sa/3.0/de/](https://creativecommons.org/licenses/by-nc-sa/3.0/de/). 

- Die Beamer Templates stammen aus dem [NPBT-Projekt](http://github.com/NMarkgraf/NPBT) von Norman Markgraf und stehen wie der Source Code unter der Lizenz [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.de.html)

