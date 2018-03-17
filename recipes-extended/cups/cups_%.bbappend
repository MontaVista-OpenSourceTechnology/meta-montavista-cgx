PR .= ".1"

do_install_append () {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        if [ -e "${D}${libdir}/cups/daemon/cups-lpd" ] ; then
            install -D ${D}${libdir}/cups/daemon/cups-lpd ${D}${libexecdir}/cups/daemon/cups-lpd
	    rm ${D}${libdir}/cups/daemon/cups-lpd
        fi

	if [ -e "${D}${systemd_system_unitdir}/org.cups.cups-lpd@.service" ] ; then
	    sed -i "s:${libdir}/cups/daemon/cups-lpd:${libexecdir}/cups/daemon/cups-lpd:g" \
	    ${D}${systemd_system_unitdir}/org.cups.cups-lpd@.service
	fi
    fi
}

inherit multilib-alternatives

MULTILIB_ALTERNATIVES_${PN} = "${sysconfdir}/cups/cups-files.conf \
                               ${sysconfdir}/cups/cups-files.conf.default \
                               "
MULTILIB_ALTERNATIVES_${PN}-dev = "${bindir}/cups-config"
MULTILIB_ALTERNATIVES_${PN} += "${@bb.utils.contains('DISTRO_FEATURES','systemd','${libexecdir}/cups/daemon/cups-lpd','',d)}"
