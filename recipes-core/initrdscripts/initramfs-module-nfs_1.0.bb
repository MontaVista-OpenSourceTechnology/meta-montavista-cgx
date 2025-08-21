SRC_URI = "file://80-nfsboot.sh"
PR = "r3"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
DESCRIPTION = "An initramfs module for booting via NFS."
RDEPENDS:${PN} = "initramfs-uniboot"
RRECOMMENDS:${PN} = "kernel-module-g-ether kernel-module-nfs"

do_install() {
	install -d ${D}/initrd.d
        install -m 0755 ${WORKDIR}/80-nfsboot.sh ${D}/initrd.d/
}

inherit allarch
FILES:${PN} += " /initrd.d/* "
