PR .= ".2"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit useradd
USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM_${PN} = "-r shutdown"
