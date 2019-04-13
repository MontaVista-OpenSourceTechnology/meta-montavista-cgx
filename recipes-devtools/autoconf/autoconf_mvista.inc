PR .= ".1"

EXTRA_OECONF += "--infodir=${datadir}/${PN}/info"
FILES_${PN}-doc += "${datadir}/${PN}/info"
