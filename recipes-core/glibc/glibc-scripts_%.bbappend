do_install() {
        SRC=$(ls -d ${STAGING_INCDIR}/glibc-scripts-internal-* | head -n 1)
	install -d -m 0755 ${D}${bindir}
	for i in ${bashscripts}; do
		install -m 0755 $SRC/$i ${D}${bindir}/
	done
}
