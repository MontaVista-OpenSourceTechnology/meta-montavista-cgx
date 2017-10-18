do_install_append_class-target () {
       mv ${D}${bindir}/grog ${D}${bindir}/grog.${PN}
       mv ${D}${bindir}/groffer ${D}${bindir}/groffer.${PN}
       mv ${D}${bindir}/gpinyin ${D}${bindir}/gpinyin.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} += "grog"
ALTERNATIVE_TARGET[grog] = "${bindir}/grog.${PN}"
ALTERNATIVE_LINK_NAME[grog] = "${bindir}/grog"

ALTERNATIVE_${PN} += "groffer"
ALTERNATIVE_TARGET[groffer] = "${bindir}/groffer.${PN}"
ALTERNATIVE_LINK_NAME[groffer] = "${bindir}/groffer"

ALTERNATIVE_${PN} += "gpinyin"
ALTERNATIVE_TARGET[gpinyin] = "${bindir}/gpinyin.${PN}"
ALTERNATIVE_LINK_NAME[gpinyin] = "${bindir}/gpinyin"

