do_install_append_class-target () {
       mv ${D}${sysconfdir}/postfix/makedefs.out ${D}${sysconfdir}/postfix/makedefs.out.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} = "${sysconfdir}/postfix/makedefs.out"
ALTERNATIVE_TARGET[makedef.out] = "${sysconfdir}/postfix/makedefs.out.${PN}"
ALTERNATIVE_LINK_NAME[makedef.out] = "${sysconfdir}/postfix/makedefs.out"

