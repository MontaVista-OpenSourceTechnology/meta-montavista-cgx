do_install_append_class-target () {
      mv ${D}${bindir}/ldd ${D}${bindir}/ldd.${PN}
}
FILES_${PN} += "/lib/ld-*"
FILES_ldd += "${bindir}/ldd.${PN}"
INSANE_SKIP_${PN} += "libdir"
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "110", "100", d)}'

pkg_postinst_ldd () {
#!/bin/sh
    update-alternatives --install ${bindir}/ldd ldd ldd.${PN} ${ALTERNATIVE_PRIORITY}
}

pkg_prerm_ldd () {
#!/bin/sh
    update-alternatives --remove ldd ldd.${PN} ${ALTERNATIVE_PRIORITY}
}

def get_mlprovides(provide,d) :
    mlvariants = d.getVar("MULTILIB_VARIANTS",True)
    rprovides = ""
    for each in mlvariants.split():
       rprovides = "%s %s-%s" % (rprovides, each, provide)
    return rprovides

RDEPENDS_${PN}-dev_append_class-target += "${@['','base-glibc-dev'][d.getVar('MLPREFIX', True) != '']} ${@['',get_mlprovides('glibc-dev', d)][d.getVar('MLPREFIX', True) == '']}"

RPROVIDES_${PN}-dev_append_class-target += "${@['',get_mlprovides('base-glibc-dev',d)][d.getVar('MLPREFIX', True) == '']}"
