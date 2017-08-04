PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGECONFIG_remove_mips64 = "qemu"
PACKAGECONFIG_remove_linux-gnuilp32 = "qemu"
