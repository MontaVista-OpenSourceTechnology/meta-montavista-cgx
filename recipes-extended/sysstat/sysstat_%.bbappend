PR .= ".2"

EXTRA_OECONF_append += "--mandir='${datadir}/${PN}/man'"
do_install_append () {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        if [ -e "${D}${libdir}/sa/sa1" ] ; then
            install -D ${D}${libdir}/sa/sa1 ${D}${libexecdir}/sa/sa1
	    rm ${D}${libdir}/sa/sa1
        fi

	if [ -e "${D}${systemd_system_unitdir}/sysstat.service" ] ; then
	    sed -i "s:${libdir}/sa/sa1:${libexecdir}/sa/sa1:g" \
	    ${D}${systemd_system_unitdir}/sysstat.service
	fi
    fi
}

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} += "${@bb.utils.contains('DISTRO_FEATURES','systemd','${libexecdir}/sa/sa1','',d)}"

FILES_${PN}-doc += "${datadir}/${PN}/man"
