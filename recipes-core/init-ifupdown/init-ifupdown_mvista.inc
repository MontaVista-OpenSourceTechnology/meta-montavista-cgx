FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_install:append () {
	install -d ${D}/etc/default/
	echo "#NONFS=1" > ${D}/etc/default/nfsroot
}

FILES:${PN} += "/etc/default/nfsroot"

PR .= ".2"
RCONFLICTS:${PN} = ""
