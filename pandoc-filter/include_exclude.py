#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
  Quick-Pandoc-Filter: include_exclude.py

  (C)opyleft in 2018-2020 by Norman Markgraf (nmarkgraf@hotmail.com)

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

exclude_flag = None

"""
 Eine Log-Datei "include_exclude.log" erzeugen um einfacher zu debuggen
"""
if os.path.exists("include_exclude.loglevel.debug"):
    DEBUGLEVEL = logging.DEBUG
elif os.path.exists("include_exclude.loglevel.info"):
    DEBUGLEVEL = logging.INFO
elif os.path.exists("include_exclude.loglevel.warning"):
    DEBUGLEVEL = logging.WARNING
elif os.path.exists("include_exclude.loglevel.error"):
    DEBUGLEVEL = logging.ERROR
else:
    DEBUGLEVEL = logging.ERROR  # .ERROR or .DEBUG  or .INFO

DEBUGLEVEL = logging.ERROR

logging.basicConfig(filename='include_exclude.log', level=DEBUGLEVEL)


def prepare(doc):
    global exclude_flag
    doc.tag_list = list(doc.get_metadata('tag', default=["all"]))
    logging.debug("Tags: "+str(doc.tag_list))
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
    
    logging.debug("-"*50)
    logging.debug("current:" + str(e))
    logging.debug("type: "+str(type(e)))
    logging.debug("current.doc:" + str(e.doc))
    logging.debug("current doc type: "+str(type(e.doc)))
    ret = e
    
    if isinstance(e, pf.Header):
        logging.info("Header found: "+str(e.content)+" ("+str(exclude_flag)+")")
        exclude_flag = False
        include_list = []
        exclude_list = []
        
        if "include" in e.attributes:
            include_list = list(map(lambda x: x.strip(), e.attributes["include"].split(",")))
            
        if "exclude" in e.attributes:
            exclude_list = list(map(lambda x: x.strip(), e.attributes["exclude"].split(",")))
            
        if "include-only" in e.attributes:
            exclude_list = ["all"]
            include_list = list(map(lambda x: x.strip(), e.attributes["include-only"].split(",")))

        # Ersetze "*" durch "all" in den Listen.
        exclude_list = ["all" if x=="*" else x for x in exclude_list]
        include_list = ["all" if x=="*" else x for x in include_list]

        logging.info("Tag-list    : "+str(doc.tag_list))
        logging.info("Include-list: "+str(include_list))
        logging.info("Exclude-list: "+str(exclude_list))


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

            
        logging.debug("------------- New exclude_flag: "+str(exclude_flag))
        
    elif exclude_flag:
        if isinstance(e.next, pf.Header):
            exclude_flag = False
            logging.info("set flag to false! (Header)")
        #if  e.next == None:
            # exclude_flag = False
            # logging.info("set flag to false! (None)")
        if exclude_flag:
            logging.info("return should be:"+str(ret))
            ret = []
            logging.info("set return to empty!"+str(ret))
            return []

    
    logging.debug("Next found: "+str(e))
    logging.debug("Next found: "+str(type(e)))

    logging.debug("return:"+str(ret))
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

    logging.debug("Start pandoc filter 'include_exclude'")
    ret = pf.run_filter(action, prepare=prepare, finalize=finalize, doc=doc)
    logging.debug("End pandoc filter 'include_exclude'")
    
    return ret


"""
 as always
"""
if __name__ == "__main__":
    main()
