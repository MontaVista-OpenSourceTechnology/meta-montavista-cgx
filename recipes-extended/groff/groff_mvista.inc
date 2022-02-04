PR .= ".1"
#encodes libdir in manpage
EXTRA_OECONF:append = " --mandir=${datadir}/man/${PN} "
