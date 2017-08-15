PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/python3:"

export READELF="${HOST_PREFIX}readelf"

do_install_append_class-target () {
       mv ${D}${bindir}/python3.5m-config ${D}${bindir}/python3.5m-config.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN}-server = "${bindir}/python3.5m-config"
ALTERNATIVE_TARGET[python3.5m-config] = "${bindir}/python3.5m-config.${PN}"
ALTERNATIVE_LINK_NAME[python3.5m-config] = "${bindir}/python3.5m-config"
