do_install_append () {
     mkdir -p ${D}${libdir}/pkgconfig
     mv ${D}${datadir}/pkgconfig/* ${D}${libdir}/pkgconfig
     rm -rf ${D}${datadir}/pkgconfig
}
