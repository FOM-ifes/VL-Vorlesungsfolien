#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
  Quick-Pandoc-Filter: MyMoodleFilter.py

  (C)opyleft in 2020 by Norman Markgraf (nmarkgraf@hotmail.com)

  Release:
  ========
  0.1   - 27.08.2020 (nm) - Erste Version
  0.2   - 27.08.2020 (nm) - Lesbarere XML-Datei.

  WICHTIG:
  ========
    Benoetigt python3 !
    -> https://www.howtogeek.com/197947/how-to-install-python-on-windows/
    oder
    -> https://www.youtube.com/watch?v=dX2-V2BocqQ
    Bei *nix und macOS Systemen muss diese Datei als "executable" markiert
    sein!
    Also bitte ein
      > chmod a+x include_exclude.py
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
import os as os  # check if file exists.
import xml.etree.ElementTree as ET
import logging  # logging fuer die 'include_exclude.log'-Datei


"""
 Eine Log-Datei "my_moodle_filter.log" erzeugen um einfacher zu debuggen
"""
if os.path.exists("my_moodle_filter.loglevel.debug"):
    DEBUGLEVEL = logging.DEBUG
elif os.path.exists("my_moodle_filter.loglevel.info"):
    DEBUGLEVEL = logging.INFO
elif os.path.exists("my_moodle_filter.loglevel.warning"):
    DEBUGLEVEL = logging.WARNING
elif os.path.exists("my_moodle_filter.loglevel.error"):
    DEBUGLEVEL = logging.ERROR
else:
    DEBUGLEVEL = logging.ERROR  # .ERROR or .DEBUG  or .INFO

DEBUGLEVEL = logging.DEBUG

logging.basicConfig(filename='my_moodle_filter.log', level=DEBUGLEVEL)


moodle_xml = ET.Element("quiz")
filenname = ""
exercise_counter = 0


def prepare(doc):
    global filename
    global exercise_counter
    global moodle_xml
    moodle_xml.text= "\n\t"
    moodle_xml.tail = "\n"
    logging.info("Create new Moodle quiz DOM")
    filename = "MyMoodleQuizes.xml"


def doExercise(e, doc):
    global moodle_xml
    global exercise_counter
    
    logging.debug("Exercise encountered!")
    
    exercise_counter += 1
    
    if not e.attributes:
        logging.warning("WARNING: No attributes!!")
        return e
        
    type = e.attributes["type"].upper()
    logging.debug("Found type attribute: "+ type)
    
    frage = pf.stringify(e).partition(":")[2]
    logging.info("Question: "+frage)
    
    if type.find("A-B") != -1:
        logging.info("Generate multichoice XML entry!")
        question = ET.SubElement( moodle_xml, "question")
        question.set("type", "multichoice")
        question.text = "\n\t\t"
        question.tail = "\n\t"
        name = ET.SubElement(question, "name")
        name.text = "\n\t\t\t"
        name.tail = "\n\t\t"
        name_text = ET.SubElement(name, "text")
        name_text.text = "\n\t\t\t\tÜbung "+str(exercise_counter)+": "+frage+"\n\t\t\t"
        name_text.tail = "\n\t\t"
        questiontext = ET.SubElement(question, "questiontext")
        questiontext.set("format", "html")
        questiontext.text = "\n\t\t\t"
        questiontext.tail = "\n\t\t"
        questiontext_text = ET.SubElement(questiontext, "text")
        questiontext_text.text = "\n\t\t\t\tÜbung "+str(exercise_counter)+": "+frage+"\n\t\t\t"
        questiontext_text.tail = "\n\t\t"
        for qst in type.split("-"):
            answer = ET.SubElement(question, "answer")
            answer.text = "\n\t\t\t"
            answer.tail = "\n\t\t"
            fraction = "0"
            if "answer" in e.attributes:
                if e.attributes["answer"].find(qst) != -1:
                    fraction = "100"
            else:
                logging.warning("NO CORRECT ANSWER FOUND!")
            answer.set("fraction", fraction)
            answer_text = ET.SubElement(answer, "text")
            answer_text.text = "\n\t\t\t\t" + qst + "\n\t\t\t"
            answer_text.tail = "\n\t\t"
        single = ET.SubElement(question, "single")
        single.text = "false"
        single.tail ="\n\t\t"
        answernumbering =  ET.SubElement(question, "answernumbering")
        answernumbering.text = "abc"
        answernumbering.tail = "\n\t"

    if type == "YESNO":
        logging.info("Generate multichoice (yes/no) XML entry!")
        question = ET.SubElement( moodle_xml, "question")
        question.set("type", "multichoice")
        question.text = "\n\t\t"
        question.tail = "\n\t"
        name = ET.SubElement(question, "name")
        name.text = "\n\t\t\t"
        name.tail = "\n\t\t"
        name_text = ET.SubElement(name, "text")
        name_text = ET.SubElement(name, "text")
        name_text.text = "\n\t\t\t\tÜbung "+str(exercise_counter)+": "+frage+"\n\t\t\t"
        name_text.tail = "\n\t\t"
        questiontext = ET.SubElement(question, "questiontext")
        questiontext.set("format", "html")
        questiontext.text = "\n\t\t\t"
        questiontext.tail = "\n\t\t"
        questiontext_text = ET.SubElement(questiontext, "text")
        questiontext_text.text = "\n\t\t\t\tÜbung "+str(exercise_counter)+": "+frage+"\n\t\t\t"
        questiontext_text.tail = "\n\t\t"
        for qst in "yes-no".split("-"):
            answer = ET.SubElement(question, "answer")
            answer.text = "\n\t\t\t"
            answer.tail = "\n\t\t"
            fraction = "0"
            if "answer" in e.attributes:
                if e.attributes["answer"].find(qst) != -1:
                    fraction = "100"
            else:
                logging.warning("NO CORRECT ANSWER FOUND!")
            answer.set("fraction", fraction)
            answer_text = ET.SubElement(answer, "text")
            answer_text.text = "\n\t\t\t\tJa\n\t\t\t" if qst.upper() =="YES" else "\n\t\t\t\tNein\n\t\t\t"
            answer_text.tail = "\n\t\t"
        single = ET.SubElement(question, "single")
        single.text = "true"
        single.tail ="\n\t\t"
        answernumbering =  ET.SubElement(question, "answernumbering")
        answernumbering.text = "abc"
        answernumbering.tail = "\n\t"

    return e


def action(e, doc):
    """Main action function for panflute.
    """
    if isinstance(e, pf.Header):
        if not e.classes:
            return e
        if "exercise" in e.classes:
            e = doExercise(e, doc)
    return e


def finalize(doc):
    """Do nothing after action, but it is necessary for 'autofilter'.

        :param doc:
        :return:
    """
    global filename
    global moodle_xml
    logging.info("Write Moodle quiz file '"+filename+"'")
    ET.ElementTree(moodle_xml).write(filename)
    pass


def main(doc=None):
    """main function.
    """

    logging.info("Start pandoc filter 'my_moodle_filter'")
    ret = pf.run_filter(action, prepare=prepare, finalize=finalize, doc=doc)
    logging.info("End pandoc filter 'my_moodle_filter'")
    
    return ret


"""
 as always
"""
if __name__ == "__main__":
    main()
