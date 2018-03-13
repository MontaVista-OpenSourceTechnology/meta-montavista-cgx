FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://mips-dynamic-linker.patch"
SRC_URI += "file://aarch64-dynamic-linkder.patch \
            file://enable-asynchronous-unwind-tables-for-mips.patch"
