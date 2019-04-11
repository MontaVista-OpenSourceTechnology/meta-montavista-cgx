PR .= ".1"

PACKAGES =+ "${PN}-bin"

FILES_${PN}-bin = "${sbindir}/dnet ${bindir}/dnet-config"
