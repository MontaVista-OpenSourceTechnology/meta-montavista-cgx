# Copyright (c) 2009 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

DRLOG ?= "${TMPDIR}/dr.log"
DRLOG_ENABLE ?= "1"

def add_drlog(d):
    import logging
    import os
    from bb.utils import mkdirhier

    logfile = d.getVar("DRLOG", True)
    mkdirhier(os.path.dirname(logfile))

    logger = logging.getLogger("BitBake")

    # Avoid adding duplicates if the handler already exists
    for h in logger.handlers:
        if getattr(h, "_is_drlog", False):
            return

    # Use a FileHandler so we don't manage file objects ourselves
    dr_handler = logging.FileHandler(logfile, mode="w")

    fmt = logging.Formatter("[%(process)d] %(levelname)s: %(message)s")
    dr_handler.setFormatter(fmt)

    # Tag it so we can find/remove it later
    dr_handler._is_drlog = True

    logger.addHandler(dr_handler)

python drlog_eventhandler () {
    from bb.event import ConfigParsed, BuildCompleted
    import logging

    if d.getVar('DRLOG_ENABLE') == '1':
        if isinstance(e, ConfigParsed):
            add_drlog(e.data)

        if isinstance(e, BuildCompleted):
            logger = logging.getLogger("BitBake")
            # Iterate over a copy since we'll remove handlers while iterating
            for h in list(logger.handlers):
                if getattr(h, "_is_drlog", False):
                    logger.removeHandler(h)
                    try:
                        h.close()
                    except Exception:
                        pass
}

addhandler drlog_eventhandler
