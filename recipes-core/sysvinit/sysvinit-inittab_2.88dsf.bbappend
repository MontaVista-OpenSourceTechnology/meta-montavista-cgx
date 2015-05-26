FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

do_install () {
install -d ${D}${sysconfdir}
install -m 0644 ${WORKDIR}/inittab ${D}${sysconfdir}/inittab
}
