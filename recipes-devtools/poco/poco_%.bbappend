# do_install copies files from the compilation directory to a holding area
do_install_append () {
        if [ "${libdir}" != "/usr/lib" ] ; then
	   mv ${D}/usr/lib ${D}${libdir}/
        fi
        cp -df ${B}/lib/libCppUnit.so* ${D}${libdir}
}
PACKAGES_prepend = " ${@bb.utils.contains('DISTRO_FEATURES', 'ptest', '${PN}-ptest', '', d)} "
FILES_${PN}-cppunit = "${libdir}/libCppUnit.so.*"
FILES_${PN}-dev += "${libdir}/libCppUnit.so"
do_install_ptest () {
       cp -rf ${B}/bin/ ${D}${PTEST_PATH}
       cp -rf ${B}/*/testsuite/data ${D}${PTEST_PATH}/bin/
       find "${D}${PTEST_PATH}" -executable -exec chrpath -d {} \;
       echo "${POCO_TESTRUNNERS}" > "${D}${PTEST_PATH}/testrunners"
}

