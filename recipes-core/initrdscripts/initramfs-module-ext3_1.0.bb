SRC_URI = "file://80-ext3.sh"
PR = "r1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
DESCRIPTION = "An initramfs module for mount ext3."
RDEPENDS:${PN} = "initramfs-uniboot"

do_install() {
    install -d ${D}/initrd.d
    install -m 0755 ${WORKDIR}/80-ext3.sh ${D}/initrd.d/
}

inherit allarch
FILES:${PN} += " /initrd.d/* "
