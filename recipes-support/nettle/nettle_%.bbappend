PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"
SRC_URI += "file://nettle-3.1.1-version-h.patch"

EXTRA_OECONF += "--enable-mini-gmp=no"
