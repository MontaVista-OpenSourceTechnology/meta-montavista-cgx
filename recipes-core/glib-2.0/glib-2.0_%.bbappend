PR .= ".3"

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}-utils = "${bindir}/gtester-report"

# Remove .la files from common area. Seems to be not needed
# for running tests.
do_install_ptest_base_append_class-target () {
    rm -f ${D}${libexecdir}/installed-tests/glib/*.la
    rm -f ${D}${libexecdir}/installed-tests/glib/modules/*.la
}
