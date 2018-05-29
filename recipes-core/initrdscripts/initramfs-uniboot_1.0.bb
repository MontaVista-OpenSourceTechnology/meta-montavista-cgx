SRC_URI = "file://init.sh"
PR = "r12"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
DESCRIPTON = "A modular initramfs init script system."
RRECOMMENDS_${PN} = "kernel-module-mtdblock"

do_install() {
	install -d 0755 ${D}/dev
	mknod ${D}/dev/console c 5 1
	install -m 0755 ${WORKDIR}/init.sh ${D}/init

	if [ "${INITRAMFS_CRYPT_KEY}" == "1" ]; then
		install -m 0600 ${INITRAMFS_CRYPT_KEYFILE} ${D}/key.image
	fi
}

PACKAGE_ARCH = "all"
FILES_${PN} += " /init "
FILES_${PN} += " /dev/ "
FILES_${PN} += " /key.image "
LICENSE="MIT"
