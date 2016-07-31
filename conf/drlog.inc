# Copyright (c) 2009 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

DRLOG ?= "${TMPDIR}/dr.log"
DRLOG_HANDLER = ""
def add_drlog(d):
    import logging
    from os.path import join

    logfile = d.getVar("DRLOG", True)
    bb.utils.mkdirhier(os.path.dirname(logfile))
    dr_logfile = logging.StreamHandler(open(logfile, "w"))
   
    format = logging.Formatter("[%(process)d] %(levelname)s: %(message)s")
    dr_logfile.setFormatter(format)

    logger = logging.getLogger("BitBake")
    logger.addHandler(dr_logfile)
    d.setVar("DRLOG_HANDLER",dr_logfile)
python drlog_eventhandler () {
    from bb.event import ConfigParsed,BuildCompleted
    import logging, sys
    if isinstance(e, ConfigParsed):
        add_drlog(e.data)
    if isinstance(e, BuildCompleted):
        drloghandler = e.data.getVar("DRLOG_HANDLER",True)
        drloghandler.close()
}

addhandler drlog_eventhandler
