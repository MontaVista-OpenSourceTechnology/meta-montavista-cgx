DESCRIPTION = "mv-target-daemon waits for MV-REQ-TARGET message via \
               UDP from DevRocket, and sends back target informations \
               such as ARCH, Linux Kernel Version, IP"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=401bad8f8e21893d0603e1a67427074b"

SRC_URI = "file://${BPN}-${PV}.tar.bz2 \
           file://mv-target-daemond \
           file://mv-target-daemond.service \
          "

PR = "r1"

inherit autotools systemd update-rc.d

B = "${S}"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "mv-target-daemond.service"

INITSCRIPT_NAME = "mv-target-daemond"
INITSCRIPT_PARAMS = "defaults 90 10"

do_configure[noexec] = "1"

do_install () {
    oe_runmake install DESTDIR="${D}"
    install -D -m 0755 ${WORKDIR}/mv-target-daemond \
    ${D}/${sysconfdir}/init.d/mv-target-daemond

    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -D -m 0644 ${WORKDIR}/mv-target-daemond.service \
        ${D}${systemd_unitdir}/system/mv-target-daemond.service
    fi
}

FILES_${PN} = "${sysconfdir} ${sbindir}"
