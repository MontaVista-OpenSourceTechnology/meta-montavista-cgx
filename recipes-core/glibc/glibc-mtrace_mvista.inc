RDEPENDS:mtrace += "${VIRTUAL-RUNTIME_update-alternatives}"

do_install:append:class-target () {
       mv ${D}${bindir}/mtrace ${D}${bindir}/mtrace.${PN}
}

def get_priority(d):
          pnMult = d.getVar("PN", True)
          bpnMult = d.getVar("BPN", True)
          if (pnMult == bpnMult):
             return "100"
          else:
             return "90"

ALTERNATIVE_PRIORITY = "${@get_priority(d)}"

pkg_postinst:${PN} () {
#!/bin/sh
    update-alternatives --install ${bindir}/mtrace mtrace mtrace.${PN} ${ALTERNATIVE_PRIORITY}
}

pkg_prerm:${PN} () {
#!/bin/sh
    update-alternatives --remove  mtrace mtrace.${PN}
}
