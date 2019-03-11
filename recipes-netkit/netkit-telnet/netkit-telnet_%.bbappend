PR .= ".1"

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
    update-alternatives --install ${bindir}/telnet telnet telnet.${PN} ${ALTERNATIVE_PRIORITY}
}

pkg_prerm_${PN} () {
#!/bin/sh
    update-alternatives --remove telnet telnet.${PN} ${ALTERNATIVE_PRIORITY}
}
