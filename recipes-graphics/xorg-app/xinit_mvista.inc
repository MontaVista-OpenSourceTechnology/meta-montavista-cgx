PR .= ".1"

# Encodes libdir in manpage
EXTRA_OECONF:append += "--mandir=${datadir}/man/${PN}"

FILES:${PN}-doc += "${datadir}/man/${PN}"
