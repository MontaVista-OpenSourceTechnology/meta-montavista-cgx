SRC_URI = "file://90-check-modules.sh"
PR = "r0"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
DESCRIPTION = "An initramfs module for checking that kernel modules exist in rootfs"
RDEPENDS_${PN} = "initramfs-uniboot"

do_install() {
	install -d ${D}/initrd.d
        install -m 0755 ${WORKDIR}/90-check-modules.sh ${D}/initrd.d/
}

PACKAGE_ARCH = "all"
FILES_${PN} += " /initrd.d/* "
LICENSE="MIT"
