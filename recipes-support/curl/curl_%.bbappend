PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-Omit-date-from-generated-manpage.patch"

BINCONFIG = "${bindir}/curl-config"

inherit binconfig-disabled
