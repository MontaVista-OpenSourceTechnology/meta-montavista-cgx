
do_install_append () {
      mv ${D}${bindir}/ldd ${D}${bindir}/ldd.${PN}
}
FILES_ldd += "${bindir}/ldd.${PN}"

ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "110", "100", d)}'
pkg_postinst_ldd () {
#!/bin/sh
    update-alternatives --install ${bindir}/ldd ldd ldd.${PN} ${ALTERNATIVE_PRIORITY}
}

pkg_prerm_ldd () {
#!/bin/sh
    update-alternatives --remove ldd ldd.${PN} ${ALTERNATIVE_PRIORITY}
}

