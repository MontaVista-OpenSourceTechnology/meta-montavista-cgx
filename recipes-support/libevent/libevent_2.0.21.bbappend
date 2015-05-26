PR .= ".3"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"
SRC_URI += "file://libevent-install-tests-and-samples.patch"

do_install_append() {
	# In multilib case, ${PN} gets prefixed, and '${PN}-${PV}-stable'
	# no longer matches directory name created by 'make install'.
	# This could be fixed by writing shell magic that generates
	# proper string by testing ${MLPREFIX} etc, but better to avoid
	# complexity and simply replace ${PN} with verbatim string in the
	# first argument of the below command. In the second argument,
	# keep ${PN} to make 'lib32-' and 'normal' packages co-installable.
	mv ${D}${datadir}/libevent-${PV}-stable ${D}${datadir}/${PN}-${PV}
        install -D -m755 ${S}/test/test.sh "${D}${datadir}/${PN}-${PV}/tests"
}

PACKAGES += "${PN}-tests ${PN}-samples"
FILES_${PN}-tests += "${datadir}/${PN}-${PV}/tests/*"
FILES_${PN}-samples += "${datadir}/${PN}-${PV}/samples/*"

FILES_${PN}-dbg += "${datadir}/${PN}-${PV}/tests/.debug \
                    ${datadir}/${PN}-${PV}/samples/.debug"
