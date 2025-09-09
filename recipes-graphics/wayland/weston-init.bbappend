FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:seco-mx8mm = " file://mv-image.png"

do_install:append() {
    install -d ${D}/usr/share/backgrounds/
    install ${UNPACKDIR}/mv-image.png ${D}/usr/share/backgrounds/
}
FILES:${PN} += " /usr/share/backgrounds/mv-image.png"
