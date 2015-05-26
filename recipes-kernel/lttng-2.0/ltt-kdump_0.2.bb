DESCRIPTION = "LTT buffers extractor/analyzer from linux kernel dump"
LICENSE = "GPLv2"
PR = "r4"
SECTION = "devel"
SRC_URI = "file://sources"
LIC_FILES_CHKSUM = "file://LICENSE;md5=79808397c3355f163c012616125c9e26"

inherit allarch

BBCLASSEXTEND = "native nativesdk"

S = "${WORKDIR}/sources"

GDB_MACRODIR = "${datadir}/gdb/macros/ltt-kdump"

do_install() {
	install -d ${D}${GDB_MACRODIR}
	install -m 0644 ${S}/ltt.py ${D}${GDB_MACRODIR}
	install -m 0644 ${S}/README ${D}${GDB_MACRODIR}
	install -m 0644 ${S}/LICENSE ${D}${GDB_MACRODIR}
}

FILES_${PN} = "${GDB_MACRODIR}"
