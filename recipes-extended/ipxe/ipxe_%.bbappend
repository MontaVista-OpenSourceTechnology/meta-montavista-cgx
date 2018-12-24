PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"
SRC_URI += "file://fix-build-error-due-to-lzma.patch;striplevel=2"
