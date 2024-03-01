SRC_URI = "file://80-loopboot.sh"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PR = "r2"
DESCRIPTION = "An initramfs module for booting a filesystem image by loopback \
               mounting it."
RDEPENDS:${PN} = "initramfs-uniboot initramfs-module-initfs"
RRECOMMENDS:${PN} = "kernel-module-loop kernel-module-vfat"

do_install() {
	install -d ${D}/initrd.d
        install -m 0755 ${WORKDIR}/80-loopboot.sh ${D}/initrd.d/
}

inherit allarch
FILES:${PN} += " /initrd.d/* "
LICENSE="MIT"
