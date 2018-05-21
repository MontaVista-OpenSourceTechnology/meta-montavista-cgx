PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://Fix-error-handling-in-gdbm.patch;striplevel=3"

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}-dev = "${bindir}/apu-1-config"
