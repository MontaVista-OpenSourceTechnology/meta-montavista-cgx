PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://vmtoolsd.init"

inherit update-rc.d

do_install_append() {
    install -d ${D}${sysconfdir}/vmware-tools
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'false', 'true', d)}; then
        install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/vmtoolsd.init ${D}${sysconfdir}/init.d/vmtoolsd
    fi
}

INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME_${PN} = "vmtoolsd"
INITSCRIPT_PARAMS_${PN} = "start 90 2 3 4 5 . stop 60 0 1 6 ."
