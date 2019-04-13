PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"
SRC_URI += "file://fix-build-error-due-to-lzma.patch;striplevel=2"
SRC_URI += "file://remove-workaround-flags-for-host.patch;striplevel=2"

DEPENDS_remove = "syslinux"
DEPENDS_append += "${@bb.utils.contains('COMPATIBLE_HOST','${TUNE_PKGARCH}',' syslinux','', d)}"
