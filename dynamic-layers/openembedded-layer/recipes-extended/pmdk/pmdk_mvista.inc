do_install() {
	oe_runmake PREFIX=${prefix} DESTDIR=${D} install

	# Copy these into the standard directories
	install -d ${D}${bindir}/
	mv ${D}/usr/local/bin/pmempool ${D}${bindir}/
	mv ${D}/usr/local/bin/daxio ${D}${bindir}/

	install -d ${D}${libdir}
	mv ${D}/usr/local/lib*/*so* ${D}${libdir}/

	install -d ${D}${libdir}/pkgconfig
	mv ${D}/usr/local/lib*/pkgconfig/*.pc ${D}${libdir}/pkgconfig/

	install -d ${D}${includedir}
	mv ${D}/usr/local/include/* ${D}${includedir}/

	# Remove uneeded files
	rm -rf ${D}/usr/local/
}
