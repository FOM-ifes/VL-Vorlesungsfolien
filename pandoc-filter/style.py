#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
  style.py (Release: 0.6.4)
  ========-----------------
  
  A Quick-Typographie-Pandoc-Panflute-Filter.

  (C)opyleft in 2018-2020 by Norman Markgraf (nmarkgraf@hotmail.com)

  Release:
  ========
  0.1   - 21.03.2018 (nm) - Erste Version
  0.2   - 25.03.2018 (nm) - Code (angebelich) "wartbarer" gemacht.
  0.3   - 08.04.2018 (nm) - Umgestellt auf Decorator Klasse
  0.3.1 - 14.06.2018 (nm) - Code noch "wartbarer" gemacht.
  0.4.0 - 27.12.2018 (nm) - Kleinere Erweiterungen.
  0.4.1 - 27.12.2018 (nm) - Umstellung auf autofilter.
  0.4.2 - 03.01.2019 (nm) - Bugfixe
  0.4.3 - 05.02.2019 (nm) - Fehler behoben.
  0.4.4 - 26.02.2019 (nm) - Kleinere Schönheitsupdates
  0.4.5 - 21.03.2019 (nm) - Unterstürtzung für "cemph" und "cstrong".
  0.5.0 - 02.05.2019 (nm) - LaTeX Paket "xspace" und "header.tex" nun via finalize eingebunden!
  0.5.1 - 06.07.2019 (nm) - Bugfix für PDF Dokumente.
  0.5.2 - 08.07.2019 (nm) - Leichte Code Anpassungen.
  0.6.0 - 08.07.2019 (nm) - Code-Refaktor
  0.6.1 - 13.07.2019 (nm) - Die "moreblocks" Idee langsam integrieren.
  0.6.2 - 17.07.2019 (nm) - Bugfix. - "slide_level" wird nun korrekt ausgelesen.
  0.6.3 - 30.07.2019 (nm) - .spacing mit top und bottom eingebaut.
  0.6.4 - 06.07.2019 (nm) - Umgang mit "HTML-Kommentaren" verbessern.


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

import logging  # logging fuer die 'typography.log'-Datei
import os as os  # check if file exists.

from decorator import *

"""
 Eine Log-Datei "style.log" erzeugen um einfacher zu debuggen
 Durch eine Datei "style.loglevel.<level>" kann mit den

    <level>=debug|info|error
 
 der level für das logging extern ausgewählt werden.
"""
if os.path.exists("style.loglevel.debug"):
    DEBUGLEVEL = logging.DEBUG
elif os.path.exists("style.loglevel.info"):
    DEBUGLEVEL = logging.INFO
elif os.path.exists("style.loglevel.warning"):
    DEBUGLEVEL = logging.WARNING
elif os.path.exists("style.loglevel.error"):
    DEBUGLEVEL = logging.ERROR
else:
    DEBUGLEVEL = logging.ERROR # .ERROR or .DEBUG  or .INFO

logging.basicConfig(filename='style.log', level=DEBUGLEVEL)

"""
 LaTeX Fontsize commands in beamer:
 \\tiny, \\scriptsize, \\footnotesize, \\small, \\normalsize (default),
 \\large, \\Large, \\LARGE, \\huge and \\Huge.

 Handle Classes ".tiny", ".scriptsize", ".footnotesize", ".small",
                ".normalsize" (default), "large", ".Large",
                ".LARGE", ".huge"" and ".Huge".
"""
FONTSIZECLASSES = (
    "tiny", "scriptsize", "footnotesize", "small",
    "normalsize", "large", "Large",
    "LARGE", "huge", "Huge")

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

slidelevel = 2


def set_decorator(doc):
    global dec

    if doc.format in ["latex", "beamer"]:
        dec = LaTeXDecorator("latex")

    if doc.format == "tex":
        dec = LaTeXDecorator("tex")

    if doc.format == "context":
        dec = LaTeXDecorator("context")

    if doc.format == "html":
        dec = HTMLDecorator()


def handle_div(e):
    """
    Handle DIV Blocks only
    """


def handle_div_and_span(e, doc):
    """
     Handle DIV and SPAN Blocks and (HTML-)Comments in gerneral
    """

    global dec

    set_decorator(doc)

    dec.handle_div(e)
    dec.handle_span(e)
    dec.handle_div_and_span(e)

    if dec.has_pre_post():
        before = after = ""
        if isinstance(e, pf.Div):
            before = dec.get_before_block()
            after = dec.get_after_block()

        if isinstance(e, pf.Span):
            before = dec.get_before_inline()
            after = dec.get_after_inline()

        e.content = [before] + list(e.content) + [after]
        return e


def handle_header_level_one(e, doc):
    """Future work!
    """
    if isinstance(e.next, pf.Div) and ("Sinnspruch" in e.next.classes):
        logging.debug("We have work to do!")


def handle_header_block_level(e, doc):
    """

    :param e:
    :param doc:
    :return:
    """
    logging.debug("handle_header_block_level: level="+str(e.level)+" classes="+str(e.classes))
    global blocktag
    tag = blocktag
    blocktag = None
    before = None
    
    if not e.classes:
        logging.debug("handle_header_block_level: no classes!")
        return

    elem = e

    if tag:
        logging.debug("handle_header_block_level: closing previose tag <"+tag+">")
        before = pf.RawBlock("\\end{" + tag + "}\n", "latex")
        if "endblock" in e.classes:
              return before

    for blocktype in TEX_BLOCKCLASSES_TAG:
        logging.debug("handle_header_block_level: probing blocktype <"+blocktype+">")
        if blocktype in e.classes:
            logging.debug("handle_header_block_level: found <"+blocktype+"> in e.classes!")
            if not isinstance(e.content, pf.ListContainer):
                logging.debug("handle_header_block_level: content is not ListContainer->" + pf.stringify(e.content))
            else:
                logging.debug("handle_header_block_level: content is Listcontainer!")
                tag = TEX_BLOCKCLASSES_TAG[blocktype]
                blocktag = tag
                if len(e.content) > 0:
                    elem = pf.Div()
                    elem.content.append(pf.Plain(*e.content))
                    first_child = elem.content[0]
                    first_child.content.insert(0, pf.RawInline("\n\\begin{" + tag + "}[", "latex"))
                    first_child.content.append(pf.RawInline("]\n", "latex"))
                else:
                    elem = pf.RawBlock("\n\\begin{" + tag + "}\n", "latex")

    if before:
        return [before, elem]
    return elem


def handle_header(e, doc):
    """

    :param e:
    :param doc:
    :return:
    """
    global blocktag
    tag = blocktag
    blocktag = None
    frmt = doc.format

    if doc.format in ("latex", "beamer"):
        frmt = "latex"

    if "endblock" in e.classes:
        return pf.RawBlock("\\end{" + str(tag) + "}\n", frmt)
        
    if tag:
        return [pf.RawBlock("\\end{" + str(tag) + "}\n", frmt), e]


def handle_comments(e, doc):
    logging.debug("handle_comments:")
    if isinstance(e, pf.RawBlock):
        if e.text.startswith('<!--') and e.text.endswith('-->'):
            if doc.format == "latex":
                logging.debug("handle_comments old:"+e.text)
                e.format = "latex"
                e.text = "% "+e.text[4:-3]+ "\n"
                logging.debug("handle_comments new:"+e.text)
                return e

#            if doc.format == "beamer":
#                logging.debug("handle_comments remove comment:"+e.text)
#                return []


def action(e, doc):
    """Main action function for panflute.
    """
    global slidelevel
    
    logging.debug("action: slidelevel="+str(slidelevel))
    if isinstance(e, pf.Header):
        logging.debug("action: is Header with level="+str(e.level))
    
    if isinstance(e, pf.Header):
        if e.level <= slidelevel:
            return handle_header(e, doc)

    if isinstance(e, (pf.Div, pf.Span)):
        return handle_div_and_span(e, doc)

    if isinstance(e, pf.RawBlock):
        return handle_comments(e, doc)

    if isinstance(e, pf.Header):
        if e.level > slidelevel:
            return handle_header_block_level(e, doc)


def _prepare(doc):
    """Do nothing before action, but it is necessary for 'autofilter'.

    :param doc: current document
    :return: current document
    """
    global slidelevel
    logging.debug("----------------- pre begin -------------------------")
    logging.debug(doc.get_metadata("output", "<-NIX->"))
    logging.debug(doc.get_metadata("output.pdf-document", "<-NIX->"))
    logging.debug(doc.get_metadata("output.beamer_presentation.slide_level", "<-NIX->"))
    slidelevel = int(doc.get_metadata('output.beamer_presentation.slide_level', 3))
    logging.debug("Slidelevel found:" + str(slidelevel))
    logging.debug("----------------- pre end ---------------------------")


def _finalize(doc):
    """Add "\\usepackage{xspace}" to header-includes

    :param doc: current document
    :return: current document
    """
    def __add_header_includes(rawstr, frmt):
        if not rawstr in doc.get_metadata("header-includes"):
            doc.metadata[hdr_inc].append(
                pf.MetaInlines(pf.RawInline(rawstr, frmt))
            )
            
    logging.debug("Finalize doc!")
    hdr_inc = "header-includes"

    # Add header-includes if necessary
    if "header-includes" not in doc.metadata:
        if doc.get_metadata("output.beamer_presentation.includes") is None:
            logging.debug("No 'header-includes' nor `includes` ? Created 'header-includes'!")
            doc.metadata["header-includes"] = pf.MetaList()
        else:
            logging.error("Found 'includes'! SAD THINK")
            exit(1)

    # Convert header-includes to MetaList if necessary

    logging.debug("Append background packages to `header-includes`")

    if not isinstance(doc.metadata[hdr_inc], pf.MetaList):
        logging.debug("The '" + hdr_inc + "' is not a list? Converted!")
        doc.metadata[hdr_inc] = pf.MetaList(doc.metadata[hdr_inc])

    frmt = doc.format

    if doc.format in ("latex", "beamer"):
        frmt = "latex"

    if doc.format in ("tex", "latex", "beamer"):
        __add_header_includes("\\usepackage[german=quotes]{csquotes}", frmt)
        __add_header_includes("\\usepackage{xspace}", frmt)
        __add_header_includes("\\InputIfFileExists{header.tex}{\\relax}{\\relax}", frmt)


def main(doc=None):
    """Main function.

    start logging, do work and close logging.

    :param doc: document to parse
    :return: parsed document
    """
    logging.debug("Start pandoc filter 'style.py'")

    ret = pf.run_filter(action,
                        prepare=_prepare,
                        finalize=_finalize,
                        doc=doc)
    logging.debug("End pandoc filter 'style.py'")
    return ret


"""
 as always
"""
if __name__ == "__main__":
    main()
