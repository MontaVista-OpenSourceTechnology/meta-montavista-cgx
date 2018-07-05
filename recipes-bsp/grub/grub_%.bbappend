PR .= ".3"

PACKAGECONFIG_append = "libdevmapper"
PACKAGECONFIG[libdevmapper] = "--enable-device-mapper,--disable-device-mapper,libdevmapper"

RDEPENDS_${PN} += "libdevmapper"
RDEPENDS_${PN} += "coreutils"

do_install_append() {
    sed  -i 's/stat/stat.coreutils/' ${D}${sysconfdir}/grub.d/10_linux
    sed  -i 's/stat/stat.coreutils/' ${D}${sysconfdir}/grub.d/20_linux_xen
}


