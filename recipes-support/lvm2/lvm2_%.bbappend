do_install_append_class-target () {
       mv ${D}${sysconfdir}/lvm/lvm.conf ${D}${sysconfdir}/lvm/lvm.conf.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} = "${sysconfdir}/lvm/lvm.conf"
ALTERNATIVE_TARGET[lvm.conf] = "${sysconfdir}/lvm/lvm.conf.${PN}"
ALTERNATIVE_LINK_NAME[lvm.conf] = "${sysconfdir}/lvm/lvm.conf"

