do_install_append_class-target () {
       mv ${D}${bindir}/mtrace ${D}${bindir}/mtrace.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} = "${bindir}/mtrace"
ALTERNATIVE_TARGET[mtrace] = "${bindir}/mtrace.${PN}"
ALTERNATIVE_LINK_NAME[mtrace] = "${bindir}/mtrace"

