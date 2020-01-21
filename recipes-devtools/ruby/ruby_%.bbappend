PR .= ".1"

do_install_append () {

    find ${D}${libdir} | grep rbconfig.rb | xargs -n 1 sed -e "s,--sysroot=${STAGING_DIR_TARGET},,g" -e "s,${HOSTTOOLS_DIR}/,," -i

}
