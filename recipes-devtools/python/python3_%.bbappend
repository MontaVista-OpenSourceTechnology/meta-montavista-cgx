PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/python3:"

export READELF="${HOST_PREFIX}readelf"
inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}-core  = "${bindir}/python3.5m-config"

