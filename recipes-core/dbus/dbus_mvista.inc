PR .= ".2"
CONFFILES_${PN} = "${sysconfdir}/${PN}-1/system.conf ${sysconfdir}/${PN}-1/session.conf"

do_configure_prepend () {
    sed -i -e 's:^configdir\(.*\)/dbus-1:configdir\1/${PN}-1:g' \
    ${S}/dbus/Makefile.in ${S}/dbus/Makefile.am ${S}/bus/Makefile.in \
    ${S}/bus/Makefile.am ${S}/tools/Makefile.in ${S}/tools/Makefile.am
}

EXTRA_OECONF_remove = "--disable-tests"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'ptest systemd x11', d)}"
PACKAGECONFIG[ptest] = "--enable-embedded-tests --enable-asserts --enable-verbose-mode,--disable-embedded-tests --disable-asserts --disable-verbose-mode"

EXTRA_OEMAKE = "${@bb.utils.contains('DISTRO_FEATURES', 'ptest', 'CFLAG_VISIBILITY=-fvisibility=default', '', d)}"
