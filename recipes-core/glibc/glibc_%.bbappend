datadir_class-target="${libdir}/share"
EXTRA_OEMAKE_class-target += "localedir=${libdir}/share/locale"
do_install_append_class-target () {
      mv ${D}${bindir}/ldd ${D}${bindir}/ldd.${PN}
      mkdir -p ${D}${prefix}/share/info
      mv ${D}${libdir}/share/info ${D}${prefix}/share/info
}
FILES_${PN}-doc += "${prefix}/share/info/*"
FILES_ldd += "${bindir}/ldd.${PN}"

ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "110", "100", d)}'

#Moving i18n caues issues with the move. Check if it exists before moving it.
do_stash_locale_mvista-cgx () {
        dest=${LOCALESTASH}
        install -d ${dest}${base_libdir} ${dest}${bindir} ${dest}${libdir} ${dest}${datadir}
        if [ "${base_libdir}" != "${libdir}" ]; then
                cp -fpPR ${D}${base_libdir}/* ${dest}${base_libdir}
        fi
        if [ -e ${D}${bindir}/localedef ]; then
                mv -f ${D}${bindir}/localedef ${dest}${bindir}
        fi
        if [ -e ${D}${libdir}/gconv ]; then
                mv -f ${D}${libdir}/gconv ${dest}${libdir}
        fi
        if [ -e ${D}${exec_prefix}/lib ]; then
                cp -fpPR ${D}${exec_prefix}/lib ${dest}${exec_prefix}
        fi
        if [ -e ${D}${datadir}/i18n -a ! -e ${dest}${datadir}/i18n ]; then
                mv ${D}${datadir}/i18n ${dest}${datadir}
        fi
        cp -fpPR ${D}${datadir}/* ${dest}${datadir}
        rm -rf ${D}${datadir}/locale/
        cp -fpPR ${WORKDIR}/SUPPORTED ${dest}

        target=${dest}/scripts
        mkdir -p $target
        for i in ${bashscripts}; do
                if [ -f ${D}${bindir}/$i ]; then
                        cp ${D}${bindir}/$i $target/
                fi
        done
}



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
