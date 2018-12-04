RDEPENDS_mtrace += "${VIRTUAL-RUNTIME_update-alternatives}"

do_install_append_class-target () {
       mv ${D}${bindir}/mtrace ${D}${bindir}/mtrace.${PN}
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
    update-alternatives --install ${bindir}/mtrace mtrace mtrace.${PN} ${ALTERNATIVE_PRIORITY}
}

pkg_prerm_${PN} () {
#!/bin/sh
    update-alternatives --remove  mtrace mtrace.${PN}
}
