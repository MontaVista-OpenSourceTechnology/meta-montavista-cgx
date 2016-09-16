PR .= ".1"
CONFFILES_${PN} = "${sysconfdir}/${PN}-1/system.conf ${sysconfdir}/${PN}-1/session.conf"

do_configure_prepend () {
    sed -i -e 's:^configdir\(.*\)/dbus-1:configdir\1/${PN}-1:g' \
    ${S}/dbus/Makefile.in ${S}/dbus/Makefile.am ${S}/bus/Makefile.in \
    ${S}/bus/Makefile.am ${S}/tools/Makefile.in ${S}/tools/Makefile.am
}
