PR .= ".1"
FILESEXTRAPATHS_append := "${THISDIR}/${BPN}-${PV}"

SRC_URI += "file://ppp-build-failure.patch"
