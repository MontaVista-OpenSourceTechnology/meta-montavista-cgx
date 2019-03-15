SUMMARY = "Tool for handling kdump dumps using ELF coredump"
DESCRIPTION = "\
        Provide a tool to take a coredump from inside a kexec \
	kernel and save it as a normal ELF coredump, including \
	making all kernel and userland threads appears as threads \
	in the ELF coredump.  That way gdb can be used to debug it. \
"
HOMEPAGE = "https://github.com/MontaVista-OpenSourceTechnology/kdump-elftool"
SECTION = "kernel/userland"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=bae3019b4c6dc4138c217864bd04331f"
DEPENDS += "elfutils"
SRC_URI = "\
	https://github.com/MontaVista-OpenSourceTechnology/kdump-elftool/releases/download/v1.4.0/kdump-elftool-1.4.0.tar.gz \
        file://0001-Fix-ARM64-kernel-address-physical-offset.patch \
        file://elf-kdump \
        file://elf-kdump.conf \
"
SRC_URI[md5sum] = "b620bf6dc68bd7d0f54ad534102bd74c"
SRC_URI[sha256sum] = "3843e1c74fccb6c0a6cf94b5e5d78e2a3b11c3e7ee13a6ecd8c8ca966ccaa79a"

inherit autotools

inherit update-rc.d

INITSCRIPT_PACKAGES = "elf-kdump"
INITSCRIPT_NAME = "elf-kdump"
INITSCRIPT_PARAMS_elf-kdump = "start 56 2 3 4 5 . stop 56 0 1 6 ."

do_install_append() {
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/elf-kdump ${D}${sysconfdir}/init.d/elf-kdump
	install -d ${D}${sysconfdir}/sysconfig
	install -m 0644 ${WORKDIR}/elf-kdump.conf ${D}${sysconfdir}/sysconfig
}

PACKAGES += "elf-kdump"

FILES_${PN} = "${bindir}/kdump-elftool"
FILES_elf-kdump = "${sysconfdir}/init.d/elf-kdump \
                 ${sysconfdir}/sysconfig/elf-kdump.conf"

RDEPENDS_elf-kdump = "gzip kexec"

RRECOMMENDS_${PN} = "elf-kdump"

# You can't have this and do kdump dumps at the same time, it will
# screw things up, the "kdump" package will reboot the system in the
# kdump kernel because it can't take a dump.
RCONFLICTS_elf-kdump = "kdump"

BBCLASSEXTEND += "native"
