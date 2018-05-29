DESCRIPTION = "Tool for handling kdump dumps"
SECTION = "kernel/userland"
HOMEPAGE = "https://github.com/MontaVista-OpenSourceTechnology/kdump-elftool"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=bae3019b4c6dc4138c217864bd04331f"
PR = "r1"
SRC_URI = "https://github.com/MontaVista-OpenSourceTechnology/kdump-elftool/releases/download/v1.3.0/kdump-elftool-1.3.0.tar.gz \
           file://elf-kdump \
           file://elf-kdump.conf \
"

inherit autotools

inherit update-rc.d

PACKAGES += "elf-kdump"
RRECOMMENDS_${PN} = "elf-kdump"

# You can't have this and do kdump dumps at the same time, it will
# screw things up, the "kdump" package will reboot the system in the
# kdump kernel because it can't take a dump.
RCONFLICTS_elf-kdump = "kdump"

INITSCRIPT_PACKAGES = "elf-kdump"
INITSCRIPT_NAME = "elf-kdump"
INITSCRIPT_PARAMS_elf-kdump = "start 56 2 3 4 5 . stop 56 0 1 6 ."

do_install_append() {
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/elf-kdump ${D}${sysconfdir}/init.d/elf-kdump
	install -d ${D}${sysconfdir}/sysconfig
	install -m 0644 ${WORKDIR}/elf-kdump.conf ${D}${sysconfdir}/sysconfig
}

FILES_${PN} = "${bindir}/kdump-elftool"
FILES_elf-kdump = "${sysconfdir}/init.d/elf-kdump \
                 ${sysconfdir}/sysconfig/elf-kdump.conf"
RDEPENDS_elf-kdump = "gzip kexec"

BBCLASSEXTEND += "native"
DEPENDS += "elfutils"
SRC_URI[md5sum] = "94fee666c7e856a6a4060bae44cc304e"
SRC_URI[sha256sum] = "31dba488108623fab14b6113bf8dcd97134abb38a3cf68a31da0ae58acb77dab"

