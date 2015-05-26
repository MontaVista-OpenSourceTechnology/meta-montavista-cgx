PR .= ".4"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://define_macro_to_get_target_glibc_version_on_host.patch"


do_configure () {
	export LSOF_CC="${CC}"
        export LSOF_AR="${AR} cr"
        export LSOF_RANLIB="${RANLIB}"
        if [ "x${EGLIBCVERSION}" != "x" ];then
                LINUX_CLIB=`echo ${EGLIBCVERSION} |sed -e 's,\.,,g'`
                LINUX_CLIB="-DGLIBCV=${LINUX_CLIB}"
                export LINUX_CLIB
        fi
        yes | ./Configure ${LSOF_OS}
}
