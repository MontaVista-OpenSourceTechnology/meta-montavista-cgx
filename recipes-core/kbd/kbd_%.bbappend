PR .= ".1"

EXTRA_OECONF += " --datadir=${datadir}/${PN}"

FILES_${PN}-consolefonts += "${datadir}/${PN}/consolefonts"
FILES_${PN}-consoletrans += "${datadir}/${PN}/consoletrans"
FILES_${PN}-keymaps += "${datadir}/${PN}/keymaps"
FILES_${PN}-unimaps += "${datadir}/${PN}/unimaps"
