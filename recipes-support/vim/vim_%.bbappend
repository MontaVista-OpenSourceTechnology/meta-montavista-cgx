ALTERNATIVE_${PN} = "vi vim xxd"
ALTERNATIVE_LINK_NAME[xxd] = "${bindir}/xxd"
do_install_append () {
    mv ${D}${bindir}/xxd ${D}${bindir}/xxd.${BPN}
}
