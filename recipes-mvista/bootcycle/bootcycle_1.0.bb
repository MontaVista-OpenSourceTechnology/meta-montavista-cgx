DESCRIPTION = "Boot cycle detection"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=401bad8f8e21893d0603e1a67427074b"

PR = "r8"

SRC_URI = "${MVL_MIRROR}/bootcycle-${PV}.tar.gz \
           file://bootcycle-init.diff;apply=yes \
           file://bootcycle-bld347.diff;apply=yes \
           file://bootcycle-man.diff;apply=yes \
           file://bootcycle_udev.patch;apply=yes \
           file://fix-bootcycle-flag.patch;apply=yes \
          "

inherit update-rc.d
INITSCRIPT_NAME = "bootcycle.sh"
INITSCRIPT_PARAMS = "start 31 S ."

do_install() {
        install -d ${D}${base_sbindir}
        install -d ${D}${localstatedir}/misc
        install -d ${D}${mandir}/man8
        install -d ${D}${sysconfdir}
        install -d ${D}${sysconfdir}/logrotate.d
        install -d ${D}${sysconfdir}/init.d
        install -d ${D}${docdir}/bootcycle

        install -m 750 ${S}/bootcycle ${D}${base_sbindir}
        install -m 750 ${S}/bootcycle-wait ${D}${base_sbindir}
        install -m 644 ${S}/bootcycle.conf ${D}${sysconfdir}
        install -m 644 ${S}/bootcycle.status ${D}${localstatedir}/misc
        install -m 644 ${S}/bootcycle.logrotate ${D}${sysconfdir}/logrotate.d
        install -m 755 ${S}/bootcycle.sh ${D}${sysconfdir}/init.d/
        install -m 755 ${S}/COPYING ${D}${docdir}/bootcycle

        gzip -c9 ${S}/bootcycle.8 >${S}/bootcycle.8.gz
        install -m 644 ${S}/bootcycle.8.gz ${D}${mandir}/man8
}

FILES_${PN} += "/var/misc"

RDEPENDS_${PN} += "bash"

SRC_URI[md5sum] = "a97f58c6fe00fa7a9063d823b40e9c5d"
SRC_URI[sha256sum] = "7c15b9ab550aa842b46d8de9f64165f245edb79d79f50c325987309fcd767aee"
