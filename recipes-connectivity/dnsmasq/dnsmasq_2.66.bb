# Copyright (c) 2013 MontaVista Software LLC.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

DESCRIPTION = "DNS forwarding application for small networks."
HOMEPAGE = "http://www.thekelleys.org.uk/dnsmasq/doc.html"
SECTION = "console/utils"
PRIORITY = "optional"
LICENSE = "LGPLv2+"

PR = "r4"

TARGET_CC_ARCH += " ${LDFLAGS} "

SRC_URI = "http://www.thekelleys.org.uk/dnsmasq/dnsmasq-${PV}.tar.gz"

do_install() {
	DESTDIR="${D}" PREFIX="${prefix}" oe_runmake install
}

SRC_URI[md5sum] = "c5eb8fb88847a5e9bf18db67c74efd47"
SRC_URI[sha256sum] = "36232fa23d1a8efc6f84a29da5ff829c2aa40df857b9116a9320ea37b651a982"

LIC_FILES_CHKSUM = "file://COPYING;md5=0636e73ff0215e8d672dc4c32c317bb3 \
		    file://COPYING-v3;md5=d32239bcb673463ab874e80d47fae504"
