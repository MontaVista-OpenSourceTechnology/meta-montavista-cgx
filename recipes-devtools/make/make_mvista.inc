PR .= ".1"

do_install_append () {
    ln -sf make ${D}${bindir}/gmake
}
