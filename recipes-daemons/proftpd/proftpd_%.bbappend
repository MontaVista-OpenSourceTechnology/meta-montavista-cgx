do_install_append_class-target () {
       mv ${D}${bindir}/prxs ${D}${bindir}/prxs.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} = "${bindir}/prxs"
ALTERNATIVE_TARGET[prxs] = "${bindir}/prxs.${PN}"
ALTERNATIVE_LINK_NAME[prxs] = "${bindir}/prxs"

