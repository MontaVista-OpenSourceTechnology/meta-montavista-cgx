PR .= ".1"

do_install_ptest_append () {
    # fix host contamination
    find ${D} -type f -not -executable -exec sed -i 's:${B}:${PTEST_PATH}:' {} \;
}
