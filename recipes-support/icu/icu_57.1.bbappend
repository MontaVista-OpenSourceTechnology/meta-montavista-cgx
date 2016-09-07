PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://remove_hardcoded_include_path.patch"

inherit binconfig-disabled
