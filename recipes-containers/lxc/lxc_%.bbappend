PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://lxc-mvlinux"

# lxc logging doesn't work well with "-O2" and above optimizations
FULL_OPTIMIZATION_arm = " -pipe ${DEBUG_FLAGS} "

do_install_append () {
    install -m 755 ${WORKDIR}/lxc-mvlinux ${D}${datadir}/lxc/templates
}
