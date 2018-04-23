PR .= ".1"

EXTRA_OECONF_append += "--mandir=${datadir}/${PN}/man"

FILES_${PN}-doc += "${datadir}/${PN}/man"
