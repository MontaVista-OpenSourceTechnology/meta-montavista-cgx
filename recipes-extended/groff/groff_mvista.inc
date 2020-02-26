PR .= ".1"
#encodes libdir in manpage
EXTRA_OECONF_append += "--mandir=${datadir}/man/${PN}"
