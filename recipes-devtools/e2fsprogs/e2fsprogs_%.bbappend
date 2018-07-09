PR .= ".1"

EXTRA_OECONF_append += "--infodir='${datadir}/${PN}/info'"

FILES_${PN}-doc += "${datadir}/${PN}/info"

ALTERNATIVE_${PN} += "mke2fs"
ALTERNATIVE_LINK_NAME[mke2fs] = "${base_sbindir}/mke2fs"
