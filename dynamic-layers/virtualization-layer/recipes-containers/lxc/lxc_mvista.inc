PR .= ".6"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://lxc-mvlinux"

# lxc logging doesn't work well with "-O2" and above optimizations
FULL_OPTIMIZATION_arm = " -pipe ${DEBUG_FLAGS} "

do_install_append () {
    install -m 755 ${WORKDIR}/lxc-mvlinux ${D}${datadir}/lxc/templates
}

do_install_ptest_append () {
    if [ -e "${D}${PTEST_PATH}/src/tests/Makefile" ] ; then
        sed -i '/bases=`echo \$\$bases`/a am__set_TESTS_bases = bases=`echo \$(TEST_LOGS) | sed \"s/\\.log//g\"`' \
        ${D}${PTEST_PATH}/src/tests/Makefile
    fi
}

# lxc needs cgroups mounted
RDEPENDS_${PN} += "${@bb.utils.contains('DISTRO_FEATURES','systemd','','cgroup-lite',d)}"
