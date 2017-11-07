inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "${sysconfdir}/cups/cups-files.conf \
                               ${sysconfdir}/cups/cups-files.conf.default \
                               "
MULTILIB_ALTERNATIVES_${PN}-dev = "${bindir}/cups-config"
