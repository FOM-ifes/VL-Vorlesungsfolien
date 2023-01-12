## Interne Links

**Wiki zu den Vorlesungsunterlagen:** [https://github.com/FOM-ifes/VL-Vorlesungsfolien/wiki](https://github.com/FOM-ifes/VL-Vorlesungsfolien/wiki)

Fehler, Hinweise etc. bitte unter [https://github.com/FOM-ifes/VL-Vorlesungsfolien/issues](https://github.com/FOM-ifes/VL-Vorlesungsfolien/issues) melden!


## Notwendige Software

- möglichst aktuelles R, RStudio, LaTeX
- LaTeX u. a. Paket `beamer`, `cm-super`, `ulem`
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


- Um eine Rohfassung der Skripte zu erzeugen, die entsprechende Rmd Datei mit dem jeweiligen Vorlesungsnamen in RStudio öffnen und knitrn.
- Sie können auch die Datei *makerender.R* anpassen und mit `source("makerender.R")` starten. So werden ggf. gleich alle drei Ausgaben (Dozentenfassung, Studierendenfassung und Lösungsskript) erstellt.
- Ebenfalls können die Skriptversionen über die batch- oder sh-Datei *makerender.bat* / *makerender.sh* erstellt werden. Eine Beschreibung über das Vorgehen findet sich weiter unten.

*Tipps*: 

- Evtl. muss zweimal geknittet werden, damit die Übungsnummerierung passt.
- Gelegentlich den Knitr Cache leeren.
- Vorsicht bei Netzlaufwerken (OneDrive etc.): hier kann es zu Schreib-/Leseproblemen kommen 

## Wo muss/kann ich etwas anpassen?

**Kontrollieren Sie die Prüfungsleistungen!** Diese sind in der Datei `Inhalte/xxx-Organisatorisches.Rmd`, wobei `xxx` für die jeweilige Vorlesung (*DES*, *QFM*, *WM*, *WMQD*) steht.

Es gibt eine Stelle, an denen Sie vor dem (ersten) Erstellen der Skripte Hand anlegen sollten:

**Erstellen einer privaten Vorstellung**

Passen Sie die Datei `Inhalte/private/privatet.R` mit Ihren Daten an. 

```
# ===========================================================================
# private.R
# =========
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# DozentInnen Information
DozInfo <- list(
  PreTitel = "Dipl.-Math.",    # "Prof. Dr.", "Dr.", ""
  PostTitel = "",              # "(MBA)", "(LL.B.)", "(M.Sc)"
  Vorname = "Norman",          # "Karla Antonia Sybilla"
  Nachname = "Markgraf" ,      # "Säuerreich-Weinenie"
  Geschlecht = "m",            # "m" männlich, "w" weiblich und "d" drittes Geschlecht
  Email = "nmarkgraf@hotmail.com", 
  WebURL = "http://www.sefiroth.net",
  Avatar = NULL,
  Telegram = "",
  WhatsApp = "",
  Skype = ""
)

# ===========================================================================
```

**Vorlesungszeitplan einfügen**

Wenn Sie eine Terminübersicht einfügen möchten, stellen Sie den Parameter showVorlesungsplan auf TRUE und passen die Datei `xxx-default.Rmd` im Ordner `Vorlesungstermine` mit Ihren Daten und Inhalten an.


**Batch-Datei verwenden**

Mit der Batch-Datei `makerender.bat` (analoges Vorgehen für `.sh`) können alle drei Skriptversionen gleichzeitig erstellt werden. Zum Ausführen der Datei wird diese in der Eingabeaufforderung (über's Terminal möglich) aufgerufen -- mittels `makerender.bat`.

Hierzu muss in der `makerender.bat` in Zeile 8 `set RSCRIPTEXE="%ProgramFiles%\R\R-4.2.1\bin\x64\Rscript.exe"` ggf. auf Ihre installierte R-Version angepasst werden und, falls R unter einem anderen Speicherort installiert sein sollte, der Pfad `%ProgramFiles%` (z.B. `C:\Benutzer\Programme` o.ä.) ebenfalls entsprechend gesetzt werden.

Folgende Parameter können für die Ausführung mit angegeben werden:

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
      
--nostudi
      Studierendenskript nicht erstellen
      
--nolsg
      Lösungsskript nicht erstellen
      
      
Die Parameter können Sie sich auch in der Eingabeaufforderung  mittels `makerender --help` auflisten lassen (vorausgesetzt die Pfade und Angaben zur R-Version sind wie oben beschrieben korrekt gesetzt).

Wenn Sie also z.B. eine Dozierendenversion der Wissenschaftlichen Methodik (Angabe des Namens der entsprechenden Rmd-Datei) erstellen wollen, mit privater Vorstellung und der Angabe von Semester und Studienort, können Sie dies über folgenden Befehl in der Kommandozeile anfordern:

```
makerender.bat -s "SoSe 2023" -o "Essen" Wissenschaftliche-Methodik
```

oder analog:

```
makerender.bat --semester="SoSe 2023" -studienort="Essen" Wissenschaftliche-Methodik
```

Die Parameter zur Personalisierung werden, bei Bedarf, zuvor in der `makerender.R` Datei auf `TRUE` gesetzt (private Vorstellung: `ShowPrivate` -- Zeile 27 -- oder Zeitplan der Vorlesung einbauen: `showVorlesungsplan` -- Zeile 34).


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

