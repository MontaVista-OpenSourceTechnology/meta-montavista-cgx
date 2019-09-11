PR .= ".3"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
           file://avoid_latex2man_pdflatex_for_docs.patch \
           file://libunwind_aarch64_ILP32_support.patch \
           file://mips_testcases_fix.patch \
           file://arm_testcases_fix.patch \
           file://ignore_invalid_regnum_in_DW_CFA_offset_extended.patch \
           file://libunwind_fix_other_test_cases_for_AARCH64_ILP32.patch \
	       file://add_attribute_used_to_retain_static_variable.patch \
           file://Add-known-failures-into-XFAILS.patch \
	       file://run-ptest \
          "

LEAD_SONAME = "libunwind"

inherit ptest

B = "${S}"

do_configure () {
    autoreconf -i
    oe_runconf
}
do_compile_ptest() {
    oe_runmake -C ${B}/tests check -i
}

do_install_ptest() {
    # copy binaries excluding ".o" files
    install -d ${D}${PTEST_PATH}
    cp -a ${B}/tests ${D}${PTEST_PATH}
    rm -f `find ${D}${PTEST_PATH} | grep "\.o$"`

    # copy dependent files for testing
    [ -f ${S}/config/test-driver ] && cp ${S}/config/test-driver ${D}${PTEST_PATH}/tests/
    cp ${S}/tests/run-* ${D}${PTEST_PATH}/tests/

    # Use libunwind libraries present in standard path and tweak Makefile
    # to run only tests
    [ -f ${D}${PTEST_PATH}/tests/Makefile ] && \
    sed -i -e "s|^\(.*\)\.log: .*(EXEEXT)|\1\.log:|" ${D}${PTEST_PATH}/tests/Makefile
    [ -f ${D}${PTEST_PATH}/tests/check-namespace.sh ] && \
    sed -i -e "s|^LIBUNWIND=.*|LIBUNWIND=${libdir}/libunwind.so|g" \
    -e "s|^LIBUNWIND_GENERIC=.*|LIBUNWIND_GENERIC=${libdir}/libunwind-\${plat}.so|g" \
    ${D}${PTEST_PATH}/tests/check-namespace.sh
}

INHIBIT_PACKAGE_STRIP = "1"

RDEPENDS_${PN}-ptest += "make bash gawk binutils"

