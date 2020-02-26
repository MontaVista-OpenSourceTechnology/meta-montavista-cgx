PR .= ".1"

# Man pages encode libdir in to content.
EXTRA_OECONF_append += "--mandir=${datadir}/man/${PN}"

FILES_${PN}-doc += "${datadir}/man/${PN}"
