PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://create_shared_liblua_library.patch"
