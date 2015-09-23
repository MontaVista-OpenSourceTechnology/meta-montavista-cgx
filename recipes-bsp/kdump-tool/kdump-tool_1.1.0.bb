DESCRIPTION = "Tool for handling kdump dumps"
SECTION = "kernel/userland"
HOMEPAGE = "https://github.com/cminyard/kdump-tool"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=bae3019b4c6dc4138c217864bd04331f"
PR = "r5"
SRC_URI = "https://github.com/cminyard/kdump-tool/releases/download/v1.1.0/kdump-tool-1.1.0.tar.gz"

SRC_URI += " \
	file://0001-Initial-ppc32-support.patch \
	file://0002-Fix-hang-processing-empty-free-list.patch \
	file://0003-Unconditionally-flush-non-flushed-page-data-at-end-o.patch \
	file://0001-Don-t-dump-16-bit-iret-sections-on-x86_64.patch \
	file://0002-Add-basic-section-handle-and-support-for-phnum-65534.patch \
	file://0001-ARM-Use-the-right-mask-for-PTEs.patch \
	"

inherit autotools

BBCLASSEXTEND += "native"
DEPENDS += "elfutils"
SRC_URI[md5sum] = "cbb6f44ace6c7cb266148beca2df3194"
SRC_URI[sha256sum] = "f4bcaa7a2d179ab47d0d7c54c78191b661d4db3dc613848c31b7b8428147bb02"

