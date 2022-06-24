PR .= ".3"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
file://0001-Avoid-latex2man-pdflatex-for-docs.patch \
file://0002-libunwind-aarch64-ilp32-support.patch \
file://0003-Fix-arm-test-cases.patch \
file://0004-Ignore-invalid-regnum-in-DM_CFA-offset-extended.patch \
file://0005-Fix-other-test-cases-for-AARCH64-ILP32.patch \
file://0006-add-attribute-used-to-retain-static-variable.patch \
file://0007-Add-known-failures-in-to-XFAILS.patch \
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
    set -x
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
    sed -i -e "s|^\(.*\)\.log: .*(EXEEXT)|\1\.log:|" \
           -e "s,--sysroot=${WORKDIR}/recipe-sysroot,," \
           -e "s,-fdebug-prefix-map=${WORKDIR}/recipe-sysroot=,," \
           -e "s,-fdebug-prefix-map=${WORKDIR}/recipe-sysroot-native=,," \
           ${D}${PTEST_PATH}/tests/Makefile
    [ -f ${D}${PTEST_PATH}/tests/check-namespace.sh ] && \
    sed -i -e "s|^LIBUNWIND=.*|LIBUNWIND=${libdir}/libunwind.so|g" \
    -e "s|^LIBUNWIND_GENERIC=.*|LIBUNWIND_GENERIC=${libdir}/libunwind-\${plat}.so|g" \
    ${D}${PTEST_PATH}/tests/check-namespace.sh
}

INHIBIT_PACKAGE_STRIP = "1"

RDEPENDS:${PN}-ptest += "make bash gawk binutils"

