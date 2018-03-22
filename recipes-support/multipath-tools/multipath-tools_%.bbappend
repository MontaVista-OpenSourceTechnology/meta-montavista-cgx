PR .= ".1"

do_compile_prepend () {
    sed -i "s:check_file,/usr/include/rados/librados.h:check_file,${STAGING_DIR_TARGET}/usr/include/rados/librados.h:g" \
    ${S}/libmultipath/checkers/Makefile
}
