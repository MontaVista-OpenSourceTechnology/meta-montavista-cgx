include ${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'recipes-kernel/linux/linux-yocto_selinux.inc', '', d)}
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'file://def-selinux.cfg', '', d)}"
