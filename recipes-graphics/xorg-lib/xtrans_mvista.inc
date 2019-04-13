do_install_append () {
      mkdir -p ${D}${libdir}
      mv ${D}${datadir}/pkgconfig ${D}${libdir}/pkgconfig
}
