inherit update-alternatives

do_install_append() {
     mv ${D}${bindir}/lsusb ${D}${bindir}/lsusb.${PN}
}

ALTERNATIVE_PRIORITY = "200"
FILES_${PN} += "${bindir}/lsusb.${PN}"
ALTERNATIVE_${PN} = "lsusb"
ALTERNATIVE_LINK_NAME[lsbusb] = "${bindir}/lsusb"

