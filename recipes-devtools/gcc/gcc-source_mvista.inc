FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://mips-dynamic-linker.patch"
SRC_URI += " \
            file://enable-asynchronous-unwind-tables-for-mips.patch"
