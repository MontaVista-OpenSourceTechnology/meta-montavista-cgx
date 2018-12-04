PR .= ".2"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

GROUPADD_PARAM_${PN} = "-r shutdown"
