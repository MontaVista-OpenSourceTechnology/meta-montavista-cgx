PR .= ".2"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit useradd
USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM:${PN} = "-r shutdown"
