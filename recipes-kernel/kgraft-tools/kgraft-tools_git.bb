DESCRIPTION="Live kernel patching"

SRC_URI = "git://github.com/useidel/kgraft-tools;protocol=https"
SRCREV="b4f069f849d7d9266310fbfaf78a765f7a3a4de7"

LICENSE="GPL-2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

S="${WORKDIR}/git"
B="${S}"

PV = "0.0.0+gitr${SRCPV}"

RDEPENDS_${PN} = "bash"

do_install () {
	install -d ${D}${bindir}
        install -m 755 *.sh ${D}${bindir}
        for script in ${D}${bindir}/*.sh; do
		sed -i $script -e s,objcopy-hacked,\$\{CROSS_COMPILE\}objcopy,
        done
}

BBCLASSEXTEND = "native nativesdk"
