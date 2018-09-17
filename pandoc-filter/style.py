#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
  Quick-Typographie-Filter: style.py

  (C)opyleft in 2018 by Norman Markgraf (nmarkgraf@hotmail.com)

  Release:
  ========
  0.1   - 21.03.2018 (nm) - Erste Version
  0.2   - 25.03.2018 (nm) - Code (angebelich) "wartbarer" gemacht.
  0.3   - 08.04.2018 (nm) - Umgestellt auf Decorator Klasse
  0.3.1 - 14.06.2018 (nm) - Code noch "wartbarer" gemacht.


  WICHTIG:
  ========
    Benoetigt python3 !
    -> https://www.howtogeek.com/197947/how-to-install-python-on-windows/
    oder
    -> https://www.youtube.com/watch?v=dX2-V2BocqQ
    Bei *nix und macOS Systemen muss diese Datei als "executable" markiert
    sein!
    Also bitte ein
      > chmod a+x style.py
   ausfuehren!


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
from decorator import *

"""
 Eine Log-Datei "style.log" erzeugen um einfacher zu debuggen
"""
DEBUGLEVEL = logging.ERROR  # .ERROR or .DEBUG  or .INFO
logging.basicConfig(filename='style.log', level=DEBUGLEVEL)

"""
 LaTeX Fontsize commands in beamer:
 \tiny, \scriptsize, \footnotesize, \small, \normalsize (default),
 \large, \Large, \LARGE, \huge and \Huge.

 Handle Classes ".tiny", ".scriptsize", ".footnotesize", ".small",
                ".normalsize" (default), "large", ".Large",
                ".LARGE", ".huge"" and ".Huge".
"""
FONTSIZECLASSES = (
    "tiny", "scriptsize", "footnotesize", "small",
    "normalsize", "large", "Large",
    "LARGE", "huge", "Huge")

BLOCKCLASSES = {
    "theorem",
    "example",
    "examples",
    "definition",
    "proof",
    "remark",
    "remarks",
    "exercise",
    "fact",
    "facts"
}

TEX_BLOCKCLASSES_TAG = {
    "theorem": "Satz",
    "example": "Beispiel",
    "examples": "Beispiele",
    "definition": "definition",
    "proof": "Beweis",
    "remark": "Bemerkung",
    "remarks": "Bemerkungen",
    "exercise": "Uebung",
    "fact": "Fakt",
    "facts": "Fakten"
}


dec = Decorator()

blocktag = None


def setDecorator(doc):
    global dec

    if doc.format in ["latex", "beamer"]:
        dec = LaTeXDecorator()

    if doc.format == "html":
        dec = HTMLDecorator()


def handleDiv(e):
    """
    Handle DIV Blocks only
    """


def handleDivAndSpan(e, doc):
    """
     Handle DIV and SPAN Blocks in gerneral
    """

    global dec

    setDecorator(doc)

    dec.handleDiv(e)
    dec.handleSpan(e)
    dec.handleDivAndSpan(e)

    if dec.hasPrePost():
        before = after = ""
        if isinstance(e, pf.Div):
            before = dec.getBeforeBlock()
            after = dec.getAfterBlock()

        if isinstance(e, pf.Span):
            before = dec.getBeforeInline()
            after = dec.getAfterInline()

        e.content = [before] + list(e.content) + [after]
        return e


def handleHeaderLevelOne(e, doc):
    """Future work!
    """
    if isinstance(e.next, pf.Div) and ("Sinnspruch" in e.next.classes):
        logging.debug("We have work to do!")


def handleHeaderBlockLevel(e, doc):
    global blocktag
    tag = blocktag
    blocktag = None
    before = None
    if tag:
        before = pf.RawBlock("\\end{"+tag+"}\n", "latex")
        if "endblock" in e.classes:
            return before

    for blocktype in BLOCKCLASSES:
        if blocktype in e.classes: 
            tag = TEX_BLOCKCLASSES_TAG[blocktype]
            elem = pf.Div()
            elem.content = [
                pf.Plain(
                    pf.RawInline("\n\\begin{"+tag+"}[", "latex"),
                    *e.content,
                    pf.RawInline("]\n", "latex")
                    )
            ]
            blocktag = tag
            if before:
                return [before, elem]
            return elem
        
        
def handleHeader(e, doc):
    global blocktag
    tag = blocktag
    blocktag = None
    if "endblock" in e.classes:
        return pf.RawBlock("\\end{"+tag+"}\n")
    if tag:
        return [pf.RawBlock("\\end{"+tag+"}\n", "latex"), e]

def action(e, doc):
    """Main action function for panflute.
    """
    if isinstance(e, pf.Header) and e.level < 4:
        return handleHeader(e, doc)

    if isinstance(e, pf.Span) or isinstance(e, pf.Div):
        return handleDivAndSpan(e, doc)

    if isinstance(e, pf.Header) and e.level == 4:
        return handleHeaderBlockLevel(e, doc)


def main():
    """main function.
    """
    logging.debug("Start style.py")
    pf.toJSONFilter(action=action)
    logging.debug("End style.py")


"""
 as always
"""
if __name__ == "__main__":
    main()
