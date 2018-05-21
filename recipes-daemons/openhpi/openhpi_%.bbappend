PR .= ".1"

SRC_URI_remove = "file://openhpi-fix-testfail-errors.patch"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"
do_install_ptest_append () {
	install -m 700 ${S}/openhpid/t/ohpi/openhpi.conf ${D}${PTEST_PATH}/openhpid/t/ohpi/openhpi.conf
}
