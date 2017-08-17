do_install_append_class-target () {
       mv ${D}${bindir}/pm-is-supported ${D}${bindir}/pm-is-supported.${PN}
       mv ${D}${sbindir}/pm-suspend ${D}${sbindir}/pm-suspend.${PN}
       mv ${D}${sbindir}/pm-hibernate ${D}${sbindir}/pm-hibernate.${PN}
       mv ${D}${sbindir}/pm-powersave ${D}${sbindir}/pm-powersave.${PN}
       mv ${D}${sbindir}/pm-suspend-hybrid ${D}${sbindir}/pm-suspend-hybrid.${PN}

}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} = "${sbindir}/pm-suspend"
ALTERNATIVE_TARGET[pm-suspend] = "${sbindir}/pm-suspend.${PN}"
ALTERNATIVE_LINK_NAME[pm-suspend] = "${sbindir}/pm-suspend"

ALTERNATIVE_${PN} = "${sbindir}/pm-hibernate"
ALTERNATIVE_TARGET[pm-hibernate] = "${sbindir}/pm-hibernate.${PN}"
ALTERNATIVE_LINK_NAME[pm-hibernate] = "${sbindir}/pm-hibernate"

ALTERNATIVE_${PN} = "${sbindir}/pm-suspend-hybrid"
ALTERNATIVE_TARGET[pm-suspend-hybrid] = "${sbindir}/pm-suspend-hybrid.${PN}"
ALTERNATIVE_LINK_NAME[pm-suspend-hybrid] = "${sbindir}/pm-suspend-hybrid"

ALTERNATIVE_${PN} = "${sbindir}/pm-suspend-powersave"
ALTERNATIVE_TARGET[pm-powersave] = "${sbindir}/pm-powersave.${PN}"
ALTERNATIVE_LINK_NAME[pm-powersave] = "${sbindir}/pm-powersave"

ALTERNATIVE_${PN} = "${bindir}/pm-is-supported"
ALTERNATIVE_TARGET[pm-is-supported] = "${bindir}/pm-is-supported.${PN}"
ALTERNATIVE_LINK_NAME[pm-is-supported] = "${bindir}/pm-is-supported"
