## Interne Links

**Wiki zu den Vorlesungsunterlagen:** [https://github.com/FOM-ifes/VL-Vorlesungsfolien/wiki](https://github.com/FOM-ifes/VL-Vorlesungsfolien/wiki)

Fehler, Hinweise etc. bitte unter [https://github.com/FOM-ifes/VL-Vorlesungsfolien/issues](https://github.com/FOM-ifes/VL-Vorlesungsfolien/issues) melden!


## Notwendige Software

- möglichst aktuelles R, RStudio, LaTeX
- LaTeX u. a. Paket `beamer`, `cm-super`, `ulem`, ggf. tinytex über `install.packages(tinytex)` und anschließend `tinytex::install_tinytex()` instalieren.
- rmarkdown in der aktuellen Version (2.19 oder später).
- pandoc in einer aktuellen Version (2.19.2) -- RStudio liefert ein integriertes Pandoc, welches aber nicht zwangsläufig dem aktuellsten entspricht. Mit dem Befehl `rmarkdown::find_pandoc()` kann man sich die von RStudio verwendete Version anzeigen lassen. Ggf. die aktuelle Version von der Pandoc Website installieren [https://pandoc.org/installing.html](https://pandoc.org/installing.html).
- Python3 mit panflute: [https://www.python.org/downloads/](https://www.python.org/downloads/). Nach der Installation über die Windows Eingabeaufforderung (Terminal) panflute installieren: `python -m pip install panflute`. Python 2.\* wird **nicht unterstützt**!!


### Wichtige zusätzliche Hinweise

- **Wichtig für macOs Nutzer\*innen:** macOS hat noch ein eigenes Python 2.7.2 installiert, welches nicht zu löschen ist. Daher bitte immer das aktuelle Python von python.org (nicht ein eigen gebrewtes!) nutzen und mit `pyhton3`oder `pip3`arbeiten!


- **Wichtig für macOs Nutzer\*innen:** Es kann sehr sinnvoll sein zu Beginn einer R Session "reticulate::py_config()" in der Console auszuführen, damit die richtigen Python Versionen benutzt werden!

- **Wichtig für Windows 10+ Nutzer\*innen:** Python muss richtig installiert werden: [https://www.howtogeek.com/197947/how-to-install-python-on-windows/](https://www.howtogeek.com/197947/how-to-install-python-on-windows/) Hierbei immer über der den Installer gehen (s. Installationsanleitung) und "Add Python 3.6 to PATH" beim ersten Installationsheinweis anklicken. Dann Computer neu starten und den Befehl (pip3 install panflute) in die Kommandozeile (unter dem Reiter "Terminal") eingeben.

- **Wichtig für Dozent\*innen mit Adobe Reader 9.0:** Leider funktioniert die Darstellung der PDF Dokumente nicht einwandfrei mit alten Adobe Readern (explizit der Adobe Reader 9.0). Bitte nutzen Sie dann Adobe Reader DC, damit klappt es in der Regel ohne Probleme.

- **Wichtig für Dozent\*innen mit Adobe Reader DC in der Version 2015.006.30503:** Leider funktioniert die Darstellung der PDF Dokumente nicht einwandfrei mit alten Adobe Readern (explizit dieser Version von DC). Bitte nutzen Sie dann aktuelle Fassungen von Adobe Reader DC, damit klappt es in der Regel ohne Probleme.

## Hinweise für den Umgang mit GitHub, RStudio, R und R Markdown

Hinweise zur Benutzung von GitHub: [http://happygitwithr.com/](http://happygitwithr.com/)

Hinweise zu RStudio, R und R Markdown: [https://ismayc.github.io/rbasics-book/](https://ismayc.github.io/rbasics-book/)

Weitere Hinweise zu R Markdown: [https://www.bookdown.org/yihui/rmarkdown-cookbook/](https://www.bookdown.org/yihui/rmarkdown-cookbook/)

## Aller erste Schritte

- Wenn Sie absolut neu sind, sollten Sie als erstes das Skript "RunMeFirst.R" im Hauptverzeichnis dieses Repositories ausführen. Hier werden eine Vielzahl an Paketen nachgeladen.

- Installieren Sie ImageMagick, falls Sie im Terminal auf die Eingabe "convert --version" keine Ausgabe der Form
```
Version: ImageMagick 7.1.0-2 Q16 x86_64 2021-06-25 https://imagemagick.org
Copyright: (C) 1999-2021 ImageMagick Studio LLC
License: https://imagemagick.org/script/license.php
Features: Cipher DPC HDRI Modules OpenMP(4.5) 
Delegates (built-in): bzlib fontconfig freetype gslib heic jng jp2 jpeg lcms lqr ltdl lzma openexr png ps tiff webp xml zlib
```

sondern eine Fehlermeldung erhalten!
  - MacOS User installieren zunächst HomeBrew (https:/brew.sh) VOLLSTÄNDIG und danach ImageMagick mit dem Befehl `brew install imagemagick`
  - Windows und Linux Nutzer:innen finden auf der Seite "https://www.imagemagick.org" Hilfe zur Installation.

- Als MacOS User können Sie ein passendes Python mit Hilfe von `brew install python3`installieren!
  

## Erste Schritte

- Um eine Rohfassung der Skripte zu erzeugen, die entsprechende `Rmd` Datei mit dem jeweiligen Vorlesungsnamen in RStudio öffnen und knitrn.
- Sie können auch die Datei `makerender.R` anpassen und mit `source("makerender.R")` starten. So werden gleich alle drei Ausgaben (Dozentenfassung, Studierendenskript und Lösungsskript) erstellt.
- Ebenfalls können die Skriptversionen über die `batch` oder `sh` Datei `makerender.bat` / `makerender.sh` erstellt werden. Eine Beschreibung über das Vorgehen findet sich weiter unten.

*Tipps*: 

- Evtl. muss zweimal geknittet werden, damit die Übungsnummerierung passt.
- Gelegentlich den Knitr Cache leeren (bei Nutzung der `Rmd` Datei).
- Vorsicht bei Netzlaufwerken (OneDrive etc.): hier kann es zu Schreib-/Leseproblemen kommen 

## Wo muss/kann ich etwas anpassen?

**Kontrollieren Sie die Prüfungsleistungen!** Diese sind in der Datei `Inhalte/xxx-Organisatorisches.Rmd`, wobei `xxx` für die Vorlesungen (*DES*, *QFM*, *WM*, *WMQD*, *QMEval*) steht.

Es gibt ein paar Stellen, an denen Sie vor dem (ersten) Erstellen der Skripte Hand anlegen sollten:

**Vorlesungszeitplan einfügen**

Wenn Sie eine Terminübersicht einfügen möchten, stellen Sie in der `makerender.R` Datei den Parameter `showVorlesungsplan` -- Zeile 34 -- auf TRUE und passen die Datei `xxx-default.Rmd` im Ordner `Vorlesungstermine` mit Ihren Daten und Inhalten an.

**Erstellen einer privaten Vorstellung**

Soll noch eine persönliche Vorstellung mit eingebaut werden, passen Sie zunächst die Datei `Inhalte/private/private.R` sowie in der Datei `Inhalte/private/private-Vorstellung.Rmd` die Abschnitte unter `[Akademische Ausbildung:]{.cstrong}` mit Ihren Daten an.

1. `Inhalte/private/private.R` anpassen:

```{r, eval=FALSE}
# ===========================================================================
# private.R
# =========
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# DozentInnen Information
DozInfo <- list(
  PreTitel = "",                # "Prof. Dr.", "Dr.", ""
  PostTitel = "",               # "(MBA), "(LL.B)", "(M.Sci)"
  Vorname = "",                 # "Karla Antonia Sybilla"
  Nachname = "" ,               # "Säuerreich-Weinenie"
  Geschlecht = "",              # "m" männlich, "w" weiblich und "d" drittes Geschlecht
  Email = "",                   # Karla.Säuerreich@fom.de
  WebURL = "",                  # www.karlasaeuerreich.de
  Avatar = NULL,
  Telegram = "",
  WhatsApp = "",
  Skype = "",
  ORCID = "",
  privateVorstellung = TRUE     # Soll eine private Vorstellung angezeugt werden?
)

# ===========================================================================
```

2. die Abschnitte unter `[Akademische Ausbildung:]{.cstrong}` in `Inhalte/private/private-Vorstellung.Rmd` anpassen:

```{r, eval=FALSE}
# ===========================================================================
# private-Vorstellung.Rmd
# =========
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

### Kurzvorstellung

::::::: {.columns} 
::: {.column width="49%" .small} 

`r paste(DozInfo$PreTitel, " ", DozInfo$Vorname, DozInfo$Nachname, " ", DozInfo$PostTitel)`


- Kontakt: [`r paste(DozInfo$Email)`](<`r paste0("mailto:",DozInfo$Email)`>)
- Homepage: [`r paste(DozInfo$WebURL)`](`r paste(DozInfo$WebURL)`)

:::
::: {.column width="49%" .footnotesize} 


[Akademische Ausbildung:]{.cstrong}

- hat studiert
- und ggfs. auch promoviert
- vielleicht sogar habiliert
    
[Beruflicher Werdegang:]{.cstrong}

- xxxx bis xxx: Spannender Job 1
- xxxx bis xxx: Spannender Job 2
- Seit yyyy: Neue Herausforderung an der FOM

[Forschungsinteressen:]{.cstrong}
- General Abstract Nonsense 1
- General Abstract Nonsense 2

:::
:::::::

# ===========================================================================
```

## Unterlagen erstellen

### Unterlagen erstellen mit der Batch-Datei

Mit der Batch-Datei `makerender.bat` (analoges Vorgehen für `.sh`) können alle drei Skriptversionen gleichzeitig erstellt werden. Zum Ausführen der Datei wird diese in der Eingabeaufforderung (über's Terminal möglich) aufgerufen.

Beim erstmaligen Verwenden der `.bat` Datei oder ggf. nach einem Update von R:
* Öffnen Sie die `.bat` Datei und passen Sie in Zeile 8 den Pfad und die R Version so an, dass er auf Ihre lokal installierte R Installation verweist: 
```
set RSCRIPTEXE="%ProgramFiles%\R\R-4.2.2\bin\x64\Rscript.exe"
``` 
Falls R nicht standardmäßig unter `"C:\Program Files"` installiert sein sollte, müsste der Pfad `%ProgramFiles%` also entsprechend angepasst werden (z.B. `C:\Benutzer\Programme` o.ä.).

* Falls das Terminal direkt in RStudio verwendet wird und dieses auf Git Bash eingestellt sein sollte (an der farbigen Pfaddarstellung zu erkennen), muss zunächst zur Eingabeaufforderung umgeschaltet werden. Hierzu kann man im Terminal `> cmd` eingeben und abschicken.
* Ist der Pfad zur R Installation korrekt gesetzt, kann man sich im Terminal mit dem Befehl `> makerender --help` die Parameter anzeigen lassen, mit denen verschiedene Optionen für die Erstellung der Unterlagen angegeben werden können. Dies ist zugleich ein guter Test, ob Pfad und Versionsnummer korrekt gesetzt sind und die Installation von R gefunden wird. Andernfalls erhält man statt der Anzeige der Hilfe eine Fehlermeldung.
* Mit dem Befehl `> makerender.bat Wissenschaftliche-Methodik` wird zunächst mit den bereits vorhandenen Voreinstellungen das Skript zur Vorlesung *Wissenschaftliche Methodik* in allen drei Fassungen (Dozierenden-, Studierenden und Lösungsskript) erstellt. Der Name der Vorlesung entspricht dem Namen der zugehörigen `Rmd` Datei.

Folgende Parameter können für die Ausführung mit angegeben werden:

```
Options: 
        -h, --help 
                show this help message and exit
        -v, --verbose
                Erweiterte Ausgabe von Laufzeitinformationen
        -c, --clean
                Zu Beginn alle temporären Dateien löschen 
        -d, --dls
                Erzeugen eines DLS Skripts
        -s SEMESTER, --semester=SEMESTER
                Semesteranagabe einstellen
        -o STUDIENORT, --studienort=STUDIENORT
                Studienort einstellen
        -l LECTURER, --lecturer=LECTURER
                Vortragende:n einstellen
        -a AUTHOR, --author=AUTHOR
                Vortragende:n einstellen
        -e LATEX-ENGINE, --lates-engine=LATEX-ENGINE
                LaTeX engine [xelatex/pdflatex/lualatex]
        --layout=LAYOUT
                Layout [FOM/eufom]
        -m MIDFIX, --midfix=MIDFIX
                Wird zwischen dem Dateinamen und der Endung eingefügt
        -p, --showprivate
                Soll eine 'Private Vorstellung' eingebaut werden?
        --nostudi
                Studierendenskript nicht erstellen
        --nolsg
                Lösungsskript nicht erstellen
```

#### Personalisierung 
Soll lediglich Name, Semester und Studienort auf Titelfolie sowie in der Fußzeile eingefügt werden, können hier die Parameter `-l`, `-s`, `-o` bzw. `--lecturer`, `--semester`, `--studienort` verwendet werden.

Wenn Sie also z.B. eine Dozierendenversion für *Wissenschaftlichen Methodik* (Angabe des Namens der entsprechenden `Rmd` Datei) erstellen wollen, mit personalisierter Angabe von Ihrem Namen, dem aktuellen Semester sowie Ort der Vorlesung, können Sie dies über folgenden Befehl in der Kommandozeile anfordern:

```
makerender.bat -o "Essen" -s "SoSe 2023" -l "Mein Titel. Mein Name" Wissenschaftliche-Methodik
```

oder analog:

```
makerender.bat --studienort="Essen" --semester="SoSe 2023" --lecturer "Mein Titel. Mein Name" Wissenschaftliche-Methodik
```

Soll eine **persönliche Vorstellungsfolie** eingefügt werden und die entsprechenden Dateien sind -- wie oben beschrieben -- angepasst, 

- Geben Sie entweder bei den Parametern im Terminal zusätzlich den Parameter `-p` oder `--showprivate` an 
- oder setzen Sie den Parameter `ShowPrivate` -- **Zeile 27** -- in der Datei `makerender.R` auf TRUE 


**Beachten Sie:**

- Sie können Ihre Angaben zu den Parametern `studienort`, `semester` und `lecturer` auch in der `makerender.R` Datei in Zeile **Zeile 41** (`Semester`), **Zeile 45** (`Dozent`) **Zeile 49** (`Studienort`) definieren.
- Wenn keine Studierendenversion und/ oder die Lösungsfolien separat erzeugt werden sollen, nutzen Sie noch zusätzlich die Parameter `--nostudi` und/ oder `--nolsg`.



### Unterlagen erstellen mit der makerender.R Datei

Wie oben beschrieben kann ein **Vorlesungszeitplan** eingefügt werden, indem `showVorlesungsplan` in **Zeile 34** auf TRUE gesetzt und die Datei `xxx-default.Rmd` im Ordner `Vorlesungstermine` mit den entsprechenden Inhalten angepasst wird. 

Zudem kann eine **private Vorstellung** eingebaut werden, wenn **Zeile 27** `ShowPrivate` auf TRUE gesetzt wird und die Datei `Inhalte/private/private.R` sowie `Inhalte/private/private-Vorstellung.Rmd` mit den eigenen Daten abgeändert wird. 

Zur Anpassung der Titelfolie sowie Fußzeilen werden nun noch 

- in **Zeile 41** das aktuelle Semester, 
- in **Zeile 45** Ihr Name, und
- in **Zeile 49** der Studienort der Vorlesung

eingetragen

Sind alle benötigten Personalisierungen und Anpassungen vorgenommen, wird die `makerender.R` Datei über den `Source` Button oder den Befehl `source("makerender.R")` gestartet. Es werden alle drei Ausgaben (Dozentenfassung, Studierendenfassung und Lösungsskript) erstellt.


### Unterlagen erstellen mit der Rmd Datei

Wenn die `Rmd` Datei genutzt wird, kann immer nur **eine** Skriptversion erstellt werden (Dozierendenskript **oder** Studierendenskript **oder** Lösungsskript).

Parameter prüfen und ggf. anpassen:

- In **Zeile 35** den Parameter `privateVorstellung` 
  - auf TRUE setzen, falls eine *private Vorstellungsfolie* erstellt werden soll und die eigenen Daten 
    - in die Datei `Inhalte/private/private.R` eingeben sowie 
    - die Abschnitte unter `[Akademische Ausbildung:]{.cstrong}` in `Inhalte/private/private-Vorstellung.Rmd` anpassen.
  - auf FALSE setzen oder lassen, wenn keine private Vorstellungsfolie integriert werden soll
- In **Zeile 36** den Parameter `showVorlesungsplan` 
  - auf TRUE setzen, falls eine Folie mit der *Terminübersicht und Themen der Veranstaltung* eingefügt werden soll und die entsprechenden Daten in der Datei `Vorlesungstermine/WM-default.Rmd` eintragen. 
  - auf FALSE setzen oder lassen, falls keine Terminübersicht hinzugefügt werden soll.
- Zur Anpassung der *Titelfolie* sowie *Fußzeilen* werden die Parameter im Aufruf `createPrivateYaml("Dozent*in", "Semester", "Studienort")` in **Zeile 47** entsprechend angepasst: 
  - Ihr Name, 
  - das aktuelle Semester, in dem die Vorlesung stattfindet (`SoSe xxx` oder `WiSe xxx`)
  - Ort der Veranstaltung.
- In **Zeile 50** im Aufruf `makeSriptOfType()` tragen Sie nun noch ein, welche Skriptversion Sie benötigen: `DozentenSkript`, `Studierendenskript` oder `LösungsSkript`.

Sind alle Parameter wie gewünscht gesetzt, kann das Skript über den `Knit` Button abgeschickt werden. 




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

