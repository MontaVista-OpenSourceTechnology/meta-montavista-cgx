SRC_URI = "file://10-initfs.sh"
PR = "r4"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
DESCRIPTION = "An initramfs module for initializing filesystems."
RDEPENDS:${PN} = "initramfs-uniboot"
RRECOMMENDS:${PN} = "kernel-module-vfat kernel-module-ext2"

do_install() {
	install -d ${D}/initrd.d
        install -m 0755 ${WORKDIR}/10-initfs.sh ${D}/initrd.d/
}

inherit allarch
FILES:${PN} += " /initrd.d/* "
LICENSE="MIT"
