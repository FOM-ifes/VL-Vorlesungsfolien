#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
  Quick-Typographie-Filter-Decorator-Class: decorator.py

  (C)opyleft in 2018-2022 by Norman Markgraf (nmarkgraf@hotmail.com)

  Release:
  ========
  please see style.py!

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


  PEP8 better pycodestyle
  =======================
    > pycodestyle decorator.py

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


class Decorator:
    FONTSIZECLASSES = (
        "tiny", "scriptsize", "footnotesize", "small",
        "normalsize", "large", "Large",
        "LARGE", "huge", "Huge")

    FONTFAMILYCLASSES = (
        "normalfont", "romanfont", "sansserif", "teletype",
        "italic", "smallcaps", "slanted", "upright")
        

    def __init__(self):
        self.pre = ""
        self.post = ""

    def add_pre_post(self, prepost=("", "")):
        self.add_pre(prepost[0])
        self.add_post(prepost[1])

    def add_post(self, post):
        self.post = post + self.post

    def add_pre(self, pre):
        self.pre = self.pre + pre

    def get_pre(self):
        return self.pre

    def get_post(self):
        return self.post

    def has_pre_post(self):
        return (self.pre != "") or (self.post != "")

    def handle_class_center(self):
        pass

    def handle_class_fontsize(self, fontsize):
        pass

    def handle_div(self, elem):
        """Handle DIV and SPAN Blocks in LaTeX Context.
        """
        pass

    def handle_span(self, elem):
        """Handle DIV and SPAN Blocks in LaTeX Context.
        """
        pass

    def handle_div_and_span(self, elem):
        pass

    def handle_comments(self, elem):
        pass

class LaTeXDecorator(Decorator):
    """
     Constants for (La)TeX
    """
    TEX_CENTER_BEFORE = """\n\\begin{center}\n"""
    TEX_CENTER_AFTER = """\n\\end{center}\n"""
    TEX_COLOR_EMPH = """\\cemph{}"""
    TEX_COLOR_STRONG = """\\cstrong{}"""
    FORMAT = "latex"

    TEX_FONTFAMILY_TAG = {
        "normalfont": "normalfont",
        "romanfont": "rmfamily",
        "sansserif": "sffamily",
        "teletype": "ttfamily",
        "slanted": "slshape",
        "italic": "itshape",
        "smallcaps": "scshape",
        "upright": "upshape"}

    def __init__(self, frmt="latex"):
        super().__init__()
        self.FORMAT = frmt

    def handle_class_center(self):
        """ Add center environment
        """
        self.add_pre(self.TEX_CENTER_BEFORE)
        self.add_post(self.TEX_CENTER_AFTER)

    def handle_class_fontsize(self, fontsize):
        """Add new fontsize.
        """
        self.add_pre("{\\" + fontsize + "{}")
        self.add_post("}")

    def handle_class_fontfamily(self, fontfamily):
        """Add new fontfamily.
        """
        self.add_pre("{\\" + self.TEX_FONTFAMILY_TAG[fontfamily] + "{}")
        self.add_post("}")

    def handle_class_color_emph(self):
        """Add new fontfamily.
        """
        self.add_pre("{" + self.TEX_COLOR_EMPH)
        self.add_post("}")

    def handle_class_color_strong(self):
        """Add new fontfamily.
        """
        self.add_pre("{" + self.TEX_COLOR_STRONG)
        self.add_post("}")

    def get_raw_block(self, txt):
        return pf.RawBlock(txt, format=self.FORMAT)

    def get_raw_inline(self, txt):
        return pf.RawInline(txt, format=self.FORMAT)

    def get_before_block(self):
        if self.has_pre_post():
            return self.get_raw_block(self.get_pre())

    def get_before_inline(self):
        if self.has_pre_post():
            return self.get_raw_inline(self.get_pre())

    def get_after_block(self):
        if self.has_pre_post():
            return self.get_raw_block(self.get_post())

    def get_after_inline(self):
        if self.has_pre_post():
            return self.get_raw_inline(self.get_post())

    def handle_class_justified_in_div(self, alignment):
        if alignment == "left":
            self.add_pre("\n\\begin{flushright}\n")
            self.add_post("\n\\end{flushright}\n")

        if alignment == "right":
            self.add_pre("\n\\begin{flushleft}\n")
            self.add_post("\n\\end{flushleft}\n")

        if alignment == "center":
            self.handle_class_center()

    def handle_class_spacing_in_div(self, attrib=[]):
        if 'top' in attrib:
            width = attrib["top"]
            if width == "fill":
                self.add_pre("\n\\vfill\n")
            else:
                self.add_pre(f"\n\\vspace*{{{width}}}\n")

        if 'bottom' in attrib:
            width = attrib["bottom"]
            if width == "fill":
                self.add_pre("\n\\vfill\n")
            else:
                self.add_post(f"\n\\vspace*{{{width}}}\n")

    def handle_div(self, elem):
        """Handle DIV Blocks in LaTeX Context.
        """
        if 'center' in elem.classes:
            self.handle_class_center()

        if 'justifiedleft' in elem.classes:
            self.handle_class_justified_in_div("left")

        if 'justifiedright' in elem.classes:
            self.handle_class_justified_in_div("right")
            
        if 'spaceing' in elem.classes:
            self.handle_class_spacing_in_div(elem.attributes)

    def handle_span(self, elem):
        """Handle SPAN Blocks in LaTeX Context.
        """

    def handle_div_and_span(self, elem):
        """Handle DIV and SPAN Blocks in LaTeX Context.
        """
        if 'cemph' in elem.classes:
            self.handle_class_color_emph()

        if 'cstrong' in elem.classes:
            self.handle_class_color_strong()

        for fontsize in self.FONTSIZECLASSES:
            if fontsize in elem.classes:
                self.handle_class_fontsize(fontsize)

        for fontfamily in self.FONTFAMILYCLASSES:
            if fontfamily in elem.classes:
                self.handle_class_fontfamily(fontfamily)

        if 'Quelle' in elem.classes:
            self.add_pre("\n{\\scriptsize{} --\\xspace{} ")
            self.add_post("}\n")

        if 'Sinnspruch' in elem.classes:
            self.add_pre("\n\\begin{quote}\\small{}")
            self.add_post("\\end{quote}\n")

        if 'personRight' in elem.classes:
            self.add_pre("\n\\begin{columns}[T]\n\t\\begin{column}[t]{0.74\\textwidth}")
            self.add_post("\n\t\\end{column}\n\t\\begin{column}[t]{0.24\\textwidth}\n\\personDB{" + elem.attributes[
                "person"] + "}\n\t\\end{column}\n\\end{columns}")
                
        if 'streching' in elem.attributes:
            self.add_pre(r"{\setstretch{"+elem.attributes['streching']+"}")
            self.add_post(r"}")


class HTMLDecorator(Decorator):
    pass


def main():
    pass


"""
 as always
"""
if __name__ == "__main__":
    main()
