SRC_URI = "file://jffs2boot.sh"
PR = "r3"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
RRECOMMENDS:${PN} = "kernel-module-mtdblock kernel-module-mtdram"

do_install() {
        install -m 0755 ${WORKDIR}/jffs2boot.sh ${D}/init
}

inherit allarch
FILES:${PN} += " /init "
LICENSE="MIT"
