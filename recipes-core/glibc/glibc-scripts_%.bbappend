do_install() {
        SRC=$(ls -d ${STAGING_INCDIR}/glibc-scripts-internal-* | head -n 1)
	install -d -m 0755 ${D}${bindir}
	for i in ${bashscripts}; do
		install -m 0755 $SRC/$i ${D}${bindir}/
	done
}

def get_sotruss_dependency (bb, d):
    import re
    binaries = bb.data.getVar('bashscripts', d, True)
    if re.search("sotruss",binaries):
        return "libsotruss"
    else:
        return ""

RDEPENDS_${PN} += "${@get_sotruss_dependency(bb, d)}"
