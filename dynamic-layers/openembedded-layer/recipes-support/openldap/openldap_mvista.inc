PR .= ".1"

libexecdir = "${libdir}/${PN}"
EXTRA_OECONF:append += "--mandir=${datadir}/${PN}/man"

FILES:${PN}-doc += "${datadir}/${PN}/man"
