do_install_append_class-target () {
       mv ${D}${bindir}/bind9-config ${D}${bindir}/bind9-config.${PN}
       mv ${D}${bindir}/isc-config.sh ${D}${bindir}/isc-config.sh.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} += "bind9-config"
ALTERNATIVE_TARGET[bind9-config] = "${bindir}/bind9-config.${PN}"
ALTERNATIVE_LINK_NAME[bind9-config] = "${bindir}/bind9-config"

ALTERNATIVE_${PN} += "isc-config.sh"
ALTERNATIVE_TARGET[isc-config.sh] = "${bindir}/isc-config.sh.${PN}"
ALTERNATIVE_LINK_NAME[isc-config.sh] = "${bindir}/isc-config.sh"


