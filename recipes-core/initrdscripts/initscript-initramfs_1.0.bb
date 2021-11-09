DESCRIPTION = "A initramfs init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
SRC_URI = "file://init-boot-initramfs.sh"

PR = "r2"

do_install() {
        install -m 0755 ${WORKDIR}/init-boot-initramfs.sh ${D}/init
}

inherit allarch

FILES:${PN} += " /init "
LICENSE="MIT"
