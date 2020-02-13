PR .= ".1"

do_install_append () {
    mkdir -p ${D}${libdir}/pkgconfig
    mv ${D}${datadir}/pkgconfig/* ${D}${libdir}/pkgconfig
    rm -rf ${D}${datadir}/pkgconfig
}
FILES_${PN}-dev += "${libdir}/pkgconfig/*.pc"
