do_install_append_class-target () {
       mv ${D}${sysconfdir}/cups/cups-files.conf ${D}${sysconfdir}/cups/cups-files.conf.${PN}
       mv ${D}${sysconfdir}/cups/cups-files.conf.default ${D}${sysconfdir}/cups/cups-files.conf.default.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} = "${sysconfdir}/cups/cups-files.conf"
ALTERNATIVE_TARGET[cups-files.conf] = "${sysconfdir}/cups/cups-files.conf.${PN}"
ALTERNATIVE_LINK_NAME[cups-files.conf] = "${sysconfdir}/cups/cups-files.conf"

ALTERNATIVE_${PN} = "${sysconfdir}/cups/cups-files.conf.defaults"
ALTERNATIVE_TARGET[cups-files.conf.defaults] = "${sysconfdir}/cups/cups-files.conf.defaults.${PN}"
ALTERNATIVE_LINK_NAME[cups-files.conf.defaults] = "${sysconfdir}/cups/cups-files.conf.defaults"

