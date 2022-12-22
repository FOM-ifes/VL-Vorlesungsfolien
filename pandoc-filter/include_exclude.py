#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# SPDX-FileCopyrightText: 2018-2021 by Norman Markgraf <nmarkgraf@hotmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
release = "1.2"
"""
  Quick-Pandoc-Filter: include_exclude.py

  (C)opyleft in 2018-2021 by Norman Markgraf (nmarkgraf@hotmail.com)

  Release:
  ========
  0.1   - 26.12.2018 (nm) - Erste Version
  0.2   - 27.12.2018 (nm) - "include-only" als Mischung von 
                            "exclude=all include=<taglist>" einbaut.
  0.3   - 03.01.2019 (nm) - Bugfixe
  0.4   - 21.02.2019 (nm) - Bugfixe. "include=yes, no , foo" wird nun 
                            richtig zu "['yes','no','foo']" gewandelt.
  0.5   - 19.02.2020 (nm) - Bugfix. Endlich auch am Ende löschen.
                            Richtig und fehlerfrei!
  0.6   - 25.08.2020 (nm) - Versuch einer Fehlerbehebung.
  1.0   - 14.07.2021 (nm) - Kleinere Aktualisierungen
  1.1   - 29.07.2021 (nm) - Bugfix. exclude-only funktioniert nun endlich.
  1.1.1   31.12.2021 (nm) - Tiny bug fixed 
  1.2     31.12.2021 (nm) - Jetzt können wir auch Tabellen richtig löschen
                            und auch das "letzter Eintrag" Problem scheint
                            gelöst!
  1.3     20.05.2022 (nm) - Kleine Änderung der Auswerte Logik.

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
import logging  # logging fuer die 'include_exclude.log'-Datei
import time  # Performace timer 

exclude_flag = None

# Eine Log-Datei "include_exclude.log" erzeugen um einfacher zu debuggen
debuglevels = {
  "debug": logging.DEBUG, 
  "info": logging.INFO, 
  "warning": logging.WARNING, 
  "error": logging.ERROR
}
for dl_key, dl_value in debuglevels.items():
  if os.path.exists("include_exclude.loglevel."+dl_key):
    DEBUGLEVEL = dl_value
    break
else:
    DEBUGLEVEL = logging.ERROR  # .ERROR or .DEBUG  or .INFO

logging.basicConfig(filename='include_exclude.log', level=DEBUGLEVEL)


def prepare(doc):
    global exclude_flag

    doc.tag_list = list(doc.get_metadata('tag', default=["all"]))
    logging.debug(f"Tags: {str(doc.tag_list)}")
    logging.info("Set exclude_flag to false!")
    exclude_flag = False


def intersection(lst1, lst2): 
    # Use of hybrid method for O(n) ...
    temp = set(lst2) 
    lst3 = [value for value in lst1 if value in temp]
    return lst3 


def intersection_not_empty(lst1, lst2):
    """Probe if the intersection of both lists is **not** empty.

    :param lst1: first list
    :param lst2: second list
    :return: True, if the intersection ist **not** empty.
    """
    return len(intersection(lst1, lst2)) > 0


def action(e, doc):
    """Main action function for panflute.
    """
    global exclude_flag

    logging.debug(78*"-")
    logging.debug(f"current: {str(e)}")
    logging.debug(f"type: {str(type(e))}")
    logging.debug(f"current.doc: {str(e.doc)}")
    logging.debug(f"current doc type: {str(type(e.doc))}")
    ret = e

    if isinstance(e, pf.Header):
        logging.info(f"Header found: {str(e.content)} ({str(exclude_flag)})")
        exclude_flag = False
        include_list = []
        exclude_list = []

        if "include-only" in e.attributes:
            exclude_list = ["all"]
            include_list = list(map(lambda x: x.strip(), e.attributes["include-only"].split(",")))

        if "exclude-only" in e.attributes:
            include_list = ["all"]
            exclude_list = list(map(lambda x: x.strip(), e.attributes["exclude-only"].split(",")))

        if "include" in e.attributes:
            include_list += list(map(lambda x: x.strip(), e.attributes["include"].split(",")))

        if "exclude" in e.attributes:
            exclude_list += list(map(lambda x: x.strip(), e.attributes["exclude"].split(",")))


        # Ersetze "*" durch "all" in den Listen.
        exclude_list = ["all" if x=="*" else x for x in exclude_list]
        include_list = ["all" if x=="*" else x for x in include_list]

        logging.info(f"Tag-list    : {str(doc.tag_list)}")
        logging.info(f"Include-list: {str(include_list)}")
        logging.info(f"Exclude-list: {str(exclude_list)}")

        if "all" in exclude_list:
            exclude_flag = True
            ret = []
            logging.info("Set flag to true and empty return! (ALL)")

        if intersection_not_empty(doc.tag_list, include_list):
            exclude_flag = False
            ret = e
            logging.info("Set flag to false and return!")

        if intersection_not_empty(doc.tag_list, exclude_list):
            exclude_flag = True
            ret = []
            logging.info("Set flag to true and empty return!")

        logging.debug(f"------------- New exclude_flag: {str(exclude_flag)}")

    elif exclude_flag:
        logging.info(f"return should be:{str(ret)}")
        ret = []
        logging.info(f"set return to empty! Prove: {str(ret)}")
        if isinstance(e, pf.Caption):
            ret = pf.Caption()  # Workaround? - I works, but why?
        if isinstance(e, pf.Doc):
            ret = None
        if isinstance(e.next, pf.Header):
            exclude_flag = False
            logging.info("set flag to false! (Header)")
        #if  e.next == None:
            # exclude_flag = False
            # logging.info("set flag to false! (None)")

    logging.debug(f"Current: {str(e)}")
    logging.debug(f"Current: {str(type(e))}")
    invert_op = getattr(e, "next", None)
    if callable(invert_op):
        logging.debug(f"Next found: {str(e.next)}")
        logging.debug(f"Next found: {str(type(e.next))}")

    logging.debug(f"return: {str(ret)}")
    return ret


def finalize(doc):
    """Do nothing after action, but it is necessary for 'autofilter'.

        :param doc:
        :return:
    """
    pass


def main(doc=None):
    """main function.
    """
    logging.info(78 * "=")
    logging.info(f"THIS IS include_exclude.py release {release}. A pandoc filter using panflute.")
    logging.info("(C) in 2018-2021 by Norman Markgraf")
    logging.debug("Start pandoc filter 'include_exclude'")
    t = time.perf_counter()
    ret = pf.run_filter(action, prepare=prepare, finalize=finalize, doc=doc)
    elapsed_time = time.perf_counter() - t
    logging.debug("End pandoc filter 'include_exclude'")
    logging.info(f"Running time: {elapsed_time} seconds.")
    logging.info(78 * "=")

    return ret


"""
 as always
"""
if __name__ == "__main__":
    main()
