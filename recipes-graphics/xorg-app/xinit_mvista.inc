PR .= ".1"

# Encodes libdir in manpage
EXTRA_OECONF_append += "--mandir=${datadir}/man/${PN}"

FILES_${PN}-doc += "${datadir}/man/${PN}"
