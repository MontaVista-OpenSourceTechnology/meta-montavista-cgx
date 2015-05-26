inherit cross
require external-mvl-toolchain.inc

do_compile[noexec] = "1"
do_configure[noexec] = "1"

do_install() {
	mkdir -p ${D}${STAGING_LIBDIR_NATIVE}/${TARGET_SYS}
	cp -a ${EXTERNAL_TOOLCHAIN}/lib/${TARGET_SYS}/* ${D}${STAGING_LIBDIR_NATIVE}/${TARGET_SYS}
}

PN = "external-mvl-toolchain-cross-${TARGET_ARCH}"
