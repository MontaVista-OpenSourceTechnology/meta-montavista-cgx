PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://use-pkgconfig-instead-of-pcre-config.patch"
