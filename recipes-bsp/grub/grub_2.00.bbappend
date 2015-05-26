PR .= ".2"

RDEPENDS_${PN} += "coreutils"

do_install_append() {
    sed  -i 's/stat/stat.coreutils/' ${D}${sysconfdir}/grub.d/10_linux
    sed  -i 's/stat/stat.coreutils/' ${D}${sysconfdir}/grub.d/20_linux_xen
}


