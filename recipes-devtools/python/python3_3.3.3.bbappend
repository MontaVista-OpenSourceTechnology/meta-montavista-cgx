PR .= ".1"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI += "file://fix_errors_with_NO_Py_DEBUG.patch"
