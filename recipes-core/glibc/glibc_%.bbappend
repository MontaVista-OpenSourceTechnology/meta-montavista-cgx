
do_install_append () {
      mv ${D}${bindir}/ldd ${D}${bindir}/ldd.${PN}
      for LDLINK in ${D}${base_libdir}/ld-*; do
          if [ -h $LDLINK -a ! -e ${D}/lib/$(basename $LDLINK) ] ; then
             mkdir -p ${D}/lib
             ln -s ..${base_libdir}/$(basename $(readlink $LDLINK)) ${D}/lib/$(basename $LDLINK)
          fi
      done
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
