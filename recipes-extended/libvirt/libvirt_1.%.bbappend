PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGECONFIG_remove_mips64 = "qemu"
PACKAGECONFIG_remove_linux-gnuilp32 = "qemu"

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "${sysconfdir}/libvirt/qemu/networks/default.xml"

