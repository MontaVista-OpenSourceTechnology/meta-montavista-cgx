do_install_append_class-target () {
       mv ${D}${bindir}/apropos ${D}${bindir}/apropos.${PN}
       mv ${D}${bindir}/whatis ${D}${bindir}/whatis.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} = "${bindir}/apropos"
ALTERNATIVE_TARGET[apropos] = "${bindir}/apropos.${PN}"
ALTERNATIVE_LINK_NAME[apropos] = "${bindir}/apropos"

ALTERNATIVE_${PN} = "${bindir}/whatis"
ALTERNATIVE_TARGET[whatis] = "${bindir}/whatis.${PN}"
ALTERNATIVE_LINK_NAME[whatis] = "${bindir}/whatis"

