do_install_append_class-target () {
       mv ${D}${sbindir}/envvars ${D}${sbindir}/envvars.${PN}
       mv ${D}${sbindir}/envvars-std ${D}${sbindir}/envvars-std.${PN}
       mv ${D}${sysconfdir}/apache2/httpd.conf ${D}${sysconfdir}/apache2/httpd.conf.${PN}
       mv ${D}${sysconfdir}/init.d/apache2 ${D}${sysconfdir}/init.d/apache2.${PN}

}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} = "${sbindir}/envvars"
ALTERNATIVE_TARGET[envvars] = "${sbindir}/envvars.${PN}"
ALTERNATIVE_LINK_NAME[envvars] = "${sbindir}/envvars"

ALTERNATIVE_${PN} = "${sbindir}/envvars-std"
ALTERNATIVE_TARGET[envvars-std] = "${sbindir}/envvars-std.${PN}"
ALTERNATIVE_LINK_NAME[envvars-std] = "${sbindir}/envvars-std"

ALTERNATIVE_${PN} = "${sysconfdir}/init.d/apache2"
ALTERNATIVE_TARGET[apache2] = "${sysconfdir}/init.d/apache2.${PN}"
ALTERNATIVE_LINK_NAME[apache2] = "${sysconfdir}/init.d/apache2"

ALTERNATIVE_${PN} = "${sysconfdir}/apache2/httpd.conf"
ALTERNATIVE_TARGET[httpd.conf] = "${sysconfdir}/apache2/httpd.conf.${PN}"
ALTERNATIVE_LINK_NAME[httpd.conf] = "${sysconfdir}/apache2/httpd.conf"
