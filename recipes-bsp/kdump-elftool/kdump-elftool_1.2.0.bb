DESCRIPTION = "Tool for handling kdump dumps"
SECTION = "kernel/userland"
HOMEPAGE = "https://github.com/MontaVista-OpenSourceTechnology/kdump-elftool"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=bae3019b4c6dc4138c217864bd04331f"
PR = "r2"
SRC_URI = "https://github.com/MontaVista-OpenSourceTechnology/kdump-elftool/releases/download/v1.2.0/kdump-elftool-1.2.0.tar.gz \
	file://0001-Fix-handling-of-x86_64-process-thread-extraction-in-.patch"

inherit autotools

BBCLASSEXTEND += "native"
DEPENDS += "elfutils"
SRC_URI[md5sum] = "0fd13bec8f1c903bd91d3b13be01fa72"
SRC_URI[sha256sum] = "0b1be46cc8bd093b2521314d4f288603fe87eefe8126ce9146842ac949f99d14"

