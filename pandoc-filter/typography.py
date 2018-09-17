#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
  Quick-Typographie-Filter: typography.py

  (C)opyleft in 2017/18 by Norman Markgraf (nmarkgraf@hotmail.com)

  Release:
  ========
  1.0.0 - 01.04.2018 (nm) - Neue Fassung aller Module
  1.0.1 - 04.04.2018 (nm) - Kleine Codeverbesserungen
  1.1.  - 14.06.2018 (nm) - Kleinere Fehler ausgebessert.

  WICHTIG:
  ========
    Benoetigt python3 !
    -> https://www.howtogeek.com/197947/how-to-install-python-on-windows/
    oder
    -> https://www.youtube.com/watch?v=dX2-V2BocqQ
    Bei *nix und macOS Systemen muss diese Datei als "executable" markiert
    sein!
    Also bitte ein
      > chmod a+x typography.py
   ausfuehren!

  LaTeX:
  ======
  Der Befehl "xspace" benötigst das Paket "xspace".
  Also bitte "usepackage{xspace}" einbauen!
  Ab Version 0.6 wird von "\," auf "thinspace" umgestellt.

  Informationen zur Typographie:
  ==============================
  URL: https://www.korrekturen.de/fehler_und_stilblueten/die_sieben_haeufigsten_typographie-suenden.shtml
  URL: http://www.typolexikon.de/abstand/
  URL: https://de.wikipedia.org/wiki/Schmales_Leerzeichen


  Lizenz:
  =======
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""

import panflute as pf  # panflute fuer den pandoc AST
import re as re  # re fuer die Regulaeren Ausdruecke
import logging  # logging fuer die 'typography.log'-Datei

# Eine Log-Datei "typography.log" erzeugen um einfacher zu debuggen
DEBUGLEVEL = logging.ERROR  # DEBUG  oder ERROR or INFO
logging.basicConfig(filename='typography.log', level=DEBUGLEVEL)

"""
 Halbeleerzeichen für LaTeX und HTML
"""
thinSpaceLaTeX = "\\thinspace{}"  # Schmales Leerzeichen in LaTeX equiv. "\,"
thinSpaceHTML = "&thinsp;"  # Schmales Leerzeichen in HTML

"""
 Das Pakete 'xspace' wird benutzt um am Ende der Einfuegung ggf. noch ein
 Leerzeichen abzuhaengen. Das wird hiermit vorbereitet:
"""
xspace = "\\xspace{}"

"""
 LaTeXt-mbox Begin und Ende
"""
beginBox = "\\mbox{"
endBox = "}"

"""
    RawInline fuer LaTeX und HTML vorbereiten
"""
inlineLatex = pf.RawInline(thinSpaceLaTeX, format="latex")
succLatex = pf.RawInline(xspace, format="latex")
inlineHTML = pf.RawInline(thinSpaceHTML, format="html")
succHTML = pf.RawInline("", format="html")

"""
 Suchmuster (pattern) für die einzelnen Situationen

 pattern1
 ========

 Dieses Pattern sucht nach x.y. in den Fassungen:
    x.y. / (x.y. / (x.y.: / (x.y.) / x.y.: ...
 für alle Buchstaben x und y abdecken.
 Wichtig ... \D, damit keine Datumsangaben in die Mangel genommen werden!
 So soll z.B. 15.9.  eben _nicht_ in Muster fallen!
"""
pattern1 = "([\(,\[,<,\{]?\w\.)(?:[~|\xa0]?)(\D\.[\),\],>]?[:,\,,\.,\!,\?]?[\),\],\},>]?)"

"""
 pattern2
 ========
 Dieses Pattern findet alle "/" am Ende einer Zeichenkette.

 Also "Test/" oder "Super/", aber nicht "/" oder "Test/Test"!
"""
pattern2 = "([\w|\(|\[|\{]+)\/$"

"""
 pattern3a/b
 ===========

 Diesen Pattern pruefen ob der vorherige und nachfolgende Text
 zu einem halben Leerzeichen fuehrt.
 Also "z. B." oder "u. a.". Die Leerzeichen werden im pandoc AST
 zu [String,c="z."][Space][String,c="B."]. Wir testen also beim [Space]
 das vorherige und nachfolgende String Element.
"""
pattern3a = "([\(,\[,<,\{]?\w\.)"
pattern3b = "^(\w\.[\),\],>]?[:,\,,\.,\!,\?]?[\),\],\},>]?)$"

"""
 pattern4
 ========
 Aufspueren von Seitenangaben: "211." und "211-212."
"""
pattern4 = "\d+[-\d+]?\.?"

"""
 pattern5
 ========
 Aufspueren von Seitenforsetzungsmarkierungen: "211 f." und "211 ff."
"""
pattern5 = "^ff?\.?$"

"""
 pattern6
 ========
 Aufspueren von Temperaturangaben mit °C oder °F in der Form 21°C korrigieren,
 ebenso cm, mm, ccm, kg, EUR, km, Meter, m und %
"""
pattern6 = "([-|+]?\d+,?-{0,2})(K[.,;:]?|°F[.,;:]?|°C[.,;:]?|€[.,;:]?|T€[.,;:]?|EUR[.,;:]?|Euro[.,;:]?|kg[.,;:]?|g[.,;:]?|km[.,;:]?|m[.,;:]?|Meter[.,;:]?|cm[.,;:]?|mm[.,;:]?|ccm[.,;:]?|\$[.,;:]?|US\-\$[.,;:]?|%[.,;:]?)$"

"""Vorkompilieren der Muster.
"""
recomp1 = re.compile(pattern1)
recomp2 = re.compile(pattern2)
recomp3a = re.compile(pattern3a)
recomp3b = re.compile(pattern3b)
recomp4 = re.compile(pattern4)
recomp5 = re.compile(pattern5)
recomp6 = re.compile(pattern6)

"""

"""


def makeLaTeXInline(a):
    """
        Erzeugt aus einer Liste von 2 oder 3 Einträgen den
        passenden LaTeX-RawInline Code:
            "\\mbox{x_y}\\xspace{}" bzw. "\\mbox{x_y_z}\\xspace{}"
        Wobei _ jeweils ein thinSpaceLaTeX ist und x,y,z die 2 bzw. 3
        Einträge in der Liste
    """
    tmp = beginBox + makeLaTeXEscapes(a[0]) + thinSpaceLaTeX + makeLaTeXEscapes(a[1])
    if len(a) > 2:
        tmp = tmp + thinSpaceLaTeX + makeLaTeXEscapes(a[2])
    tmp = tmp + endBox + xspace
    logging.debug("makeLaTeXInline: " + tmp)
    return pf.RawInline(tmp, format="latex")


def makeHTMLInline(a):
    """
        Erzeugt aus einer Liste von 2 oder 3 Einträgen den
        passenden HTML-RawInline Code:
            "x_y" bzw. "x_y_z"
        Wobei _ jeweils ein thinSpaceHTML ist und x,y,z die 2 bzw. 3
        Einträge in der Liste
    """
    tmp = a[0] + thinSpaceHTML + a[1]
    if len(a) > 2:
        tmp = tmp + thinSpaceHTML + a[2]
    logging.debug("makeHTMLInline: " + tmp)
    return pf.RawInline(tmp, format="html")


def makeInline(a, format):
    """Wähle die passende make(LaTeX/HTML)Inline gemäß dem Format aus.

    :param a:
    :param format:
    """
    if format in ("latex", "beamer"):
        return makeLaTeXInline(a)
    if format == "html":
        return makeHTMLInline(a)


def makeLaTeXEscapes(strg):
    if strg[0] in ("$", "%"):
        strg = "\\" + strg
    if strg[0:4] == "US-$":
        strg = "US-\\" + strg[3:]
    return strg


def getInline(doc):
    if doc.format == "html":
        return inlineHTML
    if doc.format in ("latex", "beamer"):
        return inlineLatex


def isThisString(e):
    return isinstance(e, pf.Str)


def isNextString(e):
    return isThisString(e.next)


def isPrevString(e):
    return isThisString(e.prev)


def isPrevAndNextString(e):
    return isNextString(e) and isPrevString(e)


def isThisSpace(e):
    return isinstance(e, pf.Space)


def isNextSpace(e):
    return isThisSpace(e.next)


def isNextParagaph(e):
    return isinstance(e.next, pf.Para)


def isStringEndsWithSlash(strg):
    return strg[-1] == "/"


def isStringSlashOnly(strg):
    return strg == "/"


def isStringAndSlash(elem):
    if isinstance(elem, pf.Str): 
        if isinstance(elem.next, pf.Str):
            return elem.next.text[0] == "/"
    return False

def isPrevNextStringThisSpace(e):
    return isThisSpace(e) and isPrevAndNextString(e)


def handleStringPattern1(elem, doc):
    splt = recomp1.split(elem.text)
    logging.debug("Pattern1 text: " + elem.text
                  + " \t split: " + str(splt))
    if len(splt) == 4:
        if splt[3] == "":
            logging.debug("Replacing " + elem.text
                          + " to " + splt[1] + "(Halfspace)"
                          + splt[2] + " at recomp1")
            return makeInline(splt[1:3], doc.format)
        else:
            logging.debug("Replacing " + elem.text
                          + " to " + splt[1] + "(Halfspace)"
                          + splt[2] + "(Halfspace)" + splt[3]
                          + " at recomp1")
            return makeInline(splt[1:4], doc.format)


def handleStringPattern6(elem, doc):
    splt = recomp6.split(elem.text)
    logging.debug("Pattern6 text: " + elem.text + " \t " + str(splt))
    if len(splt) == 4:
        if splt[0] is not None:
            splt[1] = splt[0] + splt[1]
        logging.debug("Replacing " + elem.text
                      + " to " + splt[1]
                      + "(Halfspace)" + splt[2]
                      + " at recomp6")
        return makeInline(splt[1:3], doc.format)


def handleStringPattern2(elem, doc):
    splt = recomp2.split(elem.text)
    logging.debug("Pattern2 text: " + elem.text + " \t " + str(splt))
    if len(splt) == 3 and isinstance(elem.next, pf.Space):
        logging.debug("Replacing " + elem.text
                      + " to " + splt[1]
                      + "(Halfspace)/ at recomp2")
        return [pf.Str(splt[1]), getInline(doc), pf.Str("/")]


def handleSpaceBetweenStrings(elem, doc):
    if recomp4.match(elem.next.text):
        if elem.prev.text == "S.":
            return getInline(doc)
    if recomp4.match(elem.prev.text):
        if recomp5.match(elem.next.text):
            return getInline(doc)


def handleSpacePrevString(elem, doc):
    if isPrevString(elem):
        if elem.prev.text[-1] == "/":
            return getInline(doc)


def isBetweenLongStrings(elem):
    return (len(elem.prev.text) >= 2 and
            len(elem.next.text) >= 2)


def handleBetweenLongString(elem, doc):
    mtcha = recomp3a.match(elem.prev.text)
    mtchb = recomp3b.match(elem.next.text)
    logging.debug("recomp3a-Text: " +
                  elem.prev.text +
                  " \t " + "recomp3b-Text: " +
                  elem.next.text)
    if mtcha and mtchb:
        logging.debug("Replacing (Space) to (Hlfspace) at recomp3")
        return getInline(doc)


def handleSpace(elem, doc):
    if isPrevAndNextString(elem):
        ret = handleSpaceBetweenStrings(elem, doc)
        if ret:
            return ret
    if isStringAndSlash(elem.next):
        return getInline(doc)
    ret = handleSpacePrevString(elem, doc)
    if ret:
        return ret
    if isPrevAndNextString(elem) and isBetweenLongStrings(elem):
        ret = handleBetweenLongString(elem, doc)
        if ret:
            return ret


def handleSlashAfterParagraph(elem, doc):
    if elem.text == "/" and isinstance(elem.prev, pf.Para):
        return [getInline(doc), pf.Str("/")]


def handleString(elem, doc):
    ret = handleStringPattern1(elem, doc)
    if not ret:
        ret = handleStringPattern6(elem, doc)
        if not ret:
            ret = handleStringPattern2(elem, doc)
            if not ret:
                ret = handleSlashAfterParagraph(elem, doc)
    return ret


def action(elem, doc):
    """
    """
    if isThisSpace(elem):
        return handleSpace(elem, doc)
    if isThisString(elem):
        return handleString(elem, doc)
    pass


def main():
    logging.debug("Start typography.py")
    pf.toJSONFilter(action=action)
    logging.debug("End typography.py")


if __name__ == "__main__":
    main()
