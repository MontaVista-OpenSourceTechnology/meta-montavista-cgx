# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

DESCRIPTION = "Tools for ethernet bridging."
HOMEPAGE = "http://bridge.sourceforge.net/"
SECTION = "console/network"
LICENSE = "GPLv2"
DEPENDS = "sysfsutils"
RRECOMMENDS_${PN} = "kernel-module-bridge"

INC_PR = "r3"

SRC_URI = "${SOURCEFORGE_MIRROR}/project/bridge/bridge/bridge-utils-${PV}.tar.gz \
           file://include_in6_h.patch \
	  "

inherit autotools

# Include ${STAGING_KERNEL_DIR}/include/uapi also, as UAPI header split changes
# has been taken from kernel 3.7 release
EXTRA_OECONF = "--with-linux-headers="${STAGING_KERNEL_DIR}/include/uapi -I${STAGING_KERNEL_DIR}/include""

do_install_append () {
    mv ${D}${sbindir}/brctl ${D}${sbindir}/brctl.${PN}
}

pkg_postinst_${PN} () {
    update-alternatives --install ${sbindir}/brctl brctl brctl.${PN} 100
}

pkg_prerm_${PN} () {
    update-alternatives --remove brctl brctl.${PN}
}
