PR .= ".1"

# Remove .la files from common area. Seems to be not needed
# for running tests.
do_install_ptest_base_append_class-target () {
    rm -f ${D}${libexecdir}/installed-tests/glib/*.la
}
