PR .= ".1"

PACKAGES =+ "${PN}-bin"

FILES:${PN}-bin = "${sbindir}/dnet ${bindir}/dnet-config"
