PR .= ".1"

ERROR_QA_remove = "dev-elf"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://create_shared_liblua_library.patch"
