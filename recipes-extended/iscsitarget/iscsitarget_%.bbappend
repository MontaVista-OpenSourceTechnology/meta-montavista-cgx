PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += " file://compile-with-incompatible-pointer-types.patch"
