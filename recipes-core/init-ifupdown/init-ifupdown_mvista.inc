FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_install_append () {
	install -d ${D}/etc/default/
	echo "#NONFS=1" > ${D}/etc/default/nfsroot
}

FILES_${PN} += "/etc/default/nfsroot"

PR .= ".2"
RCONFLICTS_${PN} = ""
