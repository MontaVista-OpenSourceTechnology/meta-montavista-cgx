do_install_append_class-target () {
       mv ${D}${bindir}/xtrace ${D}${bindir}/xtrace.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} += "xtrace"
ALTERNATIVE_TARGET[xtrace] = "${bindir}/xtrace.${PN}"
ALTERNATIVE_LINK_NAME[xtrace] = "${bindir}/xtrace"

