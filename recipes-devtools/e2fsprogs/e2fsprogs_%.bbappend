PR .= ".1"

EXTRA_OECONF_append += "--infodir='${datadir}/${PN}/info'"

FILES_${PN}-doc += "${datadir}/${PN}/info"
