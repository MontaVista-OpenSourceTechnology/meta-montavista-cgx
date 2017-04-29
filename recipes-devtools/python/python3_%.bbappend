PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/python3:"
SRC_URI += "file://python-3.5.2-remove-hard-coded-lib-string-for-multilib.patch"

export READELF="${HOST_PREFIX}readelf"
