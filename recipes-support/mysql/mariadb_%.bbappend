do_install_append_class-target () {
       mv ${D}${bindir}/mysqld_safe ${D}${bindir}/mysqld_safe.${PN}
       mv ${D}${bindir}/mysqlbug ${D}${bindir}/mysqlbug.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN}-server += "mysqld_safe"
ALTERNATIVE_TARGET[mysqld_safe] = "${bindir}/mysqld_safe.${PN}"
ALTERNATIVE_LINK_NAME[mysqld_safe] = "${bindir}/mysqld_safe"

ALTERNATIVE_${PN}-client += "mysqlbug"
ALTERNATIVE_TARGET[mysqlbug] = "${bindir}/mysqlbug.${PN}"
ALTERNATIVE_LINK_NAME[mysqlbug] = "${bindir}/mysqlbug"
