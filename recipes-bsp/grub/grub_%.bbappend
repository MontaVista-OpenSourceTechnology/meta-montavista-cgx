PR .= ".4"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGECONFIG_append = "libdevmapper"
PACKAGECONFIG[libdevmapper] = "--enable-device-mapper,--disable-device-mapper,libdevmapper"

RDEPENDS_${PN} += "libdevmapper"
RDEPENDS_${PN} += "coreutils"

SRC_URI += "file://0001-grub-x86-generic-failed-to-install-from-Staging.patch"

do_install_append() {
    sed  -i 's/stat/stat.coreutils/' ${D}${sysconfdir}/grub.d/10_linux
    sed  -i 's/stat/stat.coreutils/' ${D}${sysconfdir}/grub.d/20_linux_xen
}


