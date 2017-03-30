PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"
#SRC_URI += "file://nettle-3.1.1-version-h.patch"
inherit multilib_header

do_install_append () {
	oe_multilib_header nettle/version.h
}
EXTRA_OECONF += "--enable-mini-gmp=no"
