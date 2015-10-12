PR .= ".2"

# Add below configure option, to allow linker 
# (ld) from binutils-nativeto use sysroots
EXTRA_OECONF_class-native += "--with-sysroot=${prefix}"

do_install_class-native () {
	autotools_do_install

	# Install the libiberty header
	install -d ${D}${includedir}
	install -m 644 ${S}/include/ansidecl.h ${D}${includedir}
	install -m 644 ${S}/include/libiberty.h ${D}${includedir}

	# We need newer native binutils binaries to build nss-native
	# so, copy them to ${bindir}/binutils-native
	install -d ${D}/binutils-native
	mv ${D}${bindir}/* ${D}/binutils-native/
	mv ${D}/binutils-native/ ${D}${bindir}/

	# We only want libiberty, libbfd and libopcodes
	rm -rf ${D}${prefix}/${TARGET_SYS}
	rm -rf ${D}${prefix}/lib/ldscripts
	rm -rf ${D}${prefix}/share/info
	rm -rf ${D}${prefix}/share/locale
	rm -rf ${D}${prefix}/share/man
	rmdir ${D}${prefix}/share || :
	rmdir ${D}/${libdir}/gcc-lib || :
	rmdir ${D}/${libdir}64/gcc-lib || :
	rmdir ${D}/${libdir} || :
	rmdir ${D}/${libdir}64 || :
}
