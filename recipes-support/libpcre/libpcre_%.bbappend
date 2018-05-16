PR .= ".1"

do_install_ptest_append () {
	# Skip the fr_FR locale test. If the locale fr_FR is found, it is tested.
	# If not found, the test is skipped. The test program assumes fr_FR is non-UTF-8
	# locale so the test fails if fr_FR is UTF-8 locale.
	sed -i -e 's:do3=yes:do3=no:g' ${D}${PTEST_PATH}/RunTest
}
