PR .= ".1"

inherit siteinfo

do_compile_append () {
    oe_runmake CC="${CC} ${CFLAGS}" LDFLAGS="${LDFLAGS}" firmware="efi${SITEINFO_BITS}" installer
}

do_install_append () {
    oe_runmake CC="${CC} ${CFLAGS}" install INSTALLROOT="${D}" firmware="efi${SITEINFO_BITS}"
}

