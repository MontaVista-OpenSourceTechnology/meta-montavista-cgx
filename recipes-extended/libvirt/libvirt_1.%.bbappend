PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGECONFIG_remove_mips64 = "qemu"
PACKAGECONFIG_remove_linux-gnuilp32 = "qemu"

do_install_append_class-target () {
       mv ${D}${sysconfdir}/libvirt/qemu/networks/default.xml ${D}${sysconfdir}/libvirt/qemu/networks/default.xml.${PN}
}

inherit update-alternatives
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "100", "10", d)}'
ALTERNATIVE_${PN} += "default.xml"
ALTERNATIVE_TARGET[default.xml] = "${sysconfdir}/libvirt/qemu/networks/default.xml.${PN}"
ALTERNATIVE_LINK_NAME[default.xml] = "${sysconfdir}/libvirt/qemu/networks/default.xml"


