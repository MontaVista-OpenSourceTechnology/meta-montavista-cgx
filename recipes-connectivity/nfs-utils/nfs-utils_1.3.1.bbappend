PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://dont_include_host_build_flags_while_cross_compiling.patch \
           "

do_compile () {
    oe_runmake CC="$CC"
}
