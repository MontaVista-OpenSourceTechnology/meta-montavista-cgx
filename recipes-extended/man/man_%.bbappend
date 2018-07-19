PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "${bindir}/apropos ${bindir}/whatis"
