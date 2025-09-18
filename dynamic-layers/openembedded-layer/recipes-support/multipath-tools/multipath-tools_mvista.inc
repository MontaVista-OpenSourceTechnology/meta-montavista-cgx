PR .= ".3"

export mandir = "${datadir}/${PN}/man"
EXTRA_OEMAKE:append = " mandir=${datadir}/${PN}/man "

do_compile:prepend:class-target () {
    sed -i "s:check_file,/usr/include/rados/librados.h:check_file,${STAGING_DIR_TARGET}/usr/include/rados/librados.h:g" \
    ${S}/libmultipath/checkers/Makefile
}

FILES:${PN}-doc += "${datadir}/${PN}/man"
