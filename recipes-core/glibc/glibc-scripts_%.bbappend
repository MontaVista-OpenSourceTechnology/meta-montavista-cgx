RDEPENDS_${PN} += "${VIRTUAL-RUNTIME_update-alternatives}"

do_install_append_class-target () {
       mv ${D}${bindir}/xtrace ${D}${bindir}/xtrace.${PN}
       mv ${D}${bindir}/sotruss ${D}${bindir}/sotruss.${PN}
}

def get_priority(d):
          pnMult = d.getVar("PN", True)
          bpnMult = d.getVar("BPN", True)
          if (pnMult == bpnMult):
             return "100"
          else:
             return "90"

ALTERNATIVE_PRIORITY="${@get_priority(d)}"

pkg_postinst_${PN} () {
#!/bin/sh
    update-alternatives --install ${bindir}/sotruss sotruss sotruss.${PN} ${ALTERNATIVE_PRIORITY}
    update-alternatives --install ${bindir}/xtrace xtrace xtrace.${PN} ${ALTERNATIVE_PRIORITY}
}

pkg_prerm_${PN} () {
#!/bin/sh
    update-alternatives --remove  xtrace xtrace.${PN}
    update-alternatives --remove  sotruss sotruss.${PN}
}
