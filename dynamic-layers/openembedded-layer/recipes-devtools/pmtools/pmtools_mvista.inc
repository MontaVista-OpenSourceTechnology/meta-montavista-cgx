PR .= ".1"

do_install:append () {
    if [ -e "${D}${docdir}/README" ] ; then
        mv ${D}${docdir}/README ${D}${docdir}/README.${BPN}
    fi
}
