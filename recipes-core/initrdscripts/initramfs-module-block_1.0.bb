SRC_URI = "file://85-blockboot.sh"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PR = "r3"
RDEPENDS_${PN} = "initramfs-uniboot"
DESCRIPTION = "An initramfs module for booting off normal block devices."

do_install() {
	install -d ${D}/initrd.d
        install -m 0755 ${WORKDIR}/85-blockboot.sh ${D}/initrd.d/
}

PACKAGE_ARCH = "all"
FILES_${PN} += " /initrd.d/* "
LICENSE="MIT"
