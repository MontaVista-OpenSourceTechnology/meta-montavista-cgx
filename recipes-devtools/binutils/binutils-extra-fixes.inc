PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

SRC_URI_append += "file://0001-Import-patch-to-fix-PR23919-from-the-mainline.patch"
