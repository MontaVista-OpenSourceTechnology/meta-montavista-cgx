PR .= ".1"

do_install_append () {
    rm -f ${D}${libdir}/libbz2.la
}
