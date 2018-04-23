PR .= ".3"

export mandir="${datadir}/${PN}/man"
EXTRA_OEMAKE_append += "man8dir=${datadir}/${PN}/man/man8 man5dir=${datadir}/${PN}/man/man5 man3dir=${datadir}/${PN}/man/man3"

do_compile_prepend_class-target () {
    sed -i "s:check_file,/usr/include/rados/librados.h:check_file,${STAGING_DIR_TARGET}/usr/include/rados/librados.h:g" \
    ${S}/libmultipath/checkers/Makefile
}

FILES_${PN}-doc += "${datadir}/${PN}/man"
