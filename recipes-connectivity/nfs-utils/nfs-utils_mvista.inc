PR .= ".4"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://dont_include_host_build_flags_while_cross_compiling.patch "

do_compile () {
    oe_runmake CC="$CC"
}

do_install_append () {
    touch ${D}${sysconfdir}/exports
}
FILES_${PN} += "${sysconfdir}/exports"
