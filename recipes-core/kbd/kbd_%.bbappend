PR .= ".2"

EXTRA_OECONF += " --datadir=${datadir}/${PN}"
EXTRA_OECONF_append += "--mandir=${datadir}/${PN}/man"

FILES_${PN}-consolefonts += "${datadir}/${PN}/consolefonts"
FILES_${PN}-consoletrans += "${datadir}/${PN}/consoletrans"
FILES_${PN}-keymaps += "${datadir}/${PN}/keymaps"
FILES_${PN}-unimaps += "${datadir}/${PN}/unimaps"
FILES_${PN}-doc += "${datadir}/${PN}/man"
