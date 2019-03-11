SUMMARY = "PMDK Library"
DESCRIPTION = "PMDK (Persistent Memory Development Kit) library is required for the applications \
               to access the persistent memory from os. Applications use the APIs from PMDK lib \
               to load and store directly to the persistent memory by using the DAX \
               (Direct Access Feature) from os. Currently PMDK is supported by Intel and ARM (experimental)."

AUTHOR = "Harish Gurram <hgurram@mvista.com>"
HOMEPAGE = "https://pmem.io/pmdk/"

LICENSE = "Intel"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7db1106255a1baa80391fd2e21eebab7"

SRCREV = "9fe9482e985f3fda9c990f7706a477da9a349bcd"
SRC_URI = "git://github.com/pmem/pmdk.git; \
           file://jemalloc_makefile.patch \
           file://disable-installing-doc.patch \
	  "

S = "${WORKDIR}/git/"
PV = "1.4+git${SRCPV}"
PR = "r1"

inherit autotools-brokensep pkgconfig

export GIT_SSL_NO_VERIFY="true"

do_configure () {
    echo "${CONFIGUREOPTS}" >> ${S}/src/jemalloc/jemalloc.cfg
}

do_compile () {
	oe_runmake CC="${CC}"
}

do_install() {
	oe_runmake bindir='${bindir}' LIBDIR='${D}${libdir}' includedir='${includedir}' sysconfdir='${sysconfdir}' \
		   libdir='${libdir}' datadir='${datadir}' mandir='${mandir}' DESTDIR='${D}' install
	rm -rf ${D}${libdir}/pmdk_debug

}
