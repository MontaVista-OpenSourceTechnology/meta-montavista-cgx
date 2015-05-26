# Copyright (c) 2013 MontaVista Software LLC.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

require lxc.inc

SRC_URI += " \
        file://lxc_configure-container-architecture.patch \
        file://lxc-dont_recreate_vlan_or_phys_interface.patch \
	file://lxc-Cast-time_t-to-long-when-logging.patch \
       "

PR = "${INC_PR}.7"

EXTRA_OECONF += "--disable-rpath"

do_install_append() {
    install -m755 ${WORKDIR}/lxc-mvlinux "${D}/${datadir}/lxc/templates"
}

SRC_URI[md5sum] = "8552a4479090616f4bc04d8473765fc9"
SRC_URI[sha256sum] = "1e1767eae6cc5fbf892c0e193d25da420ba19f2db203716c38f7cdea3b654120"

LIC_FILES_CHKSUM = "file://COPYING;md5=4fbd65380cdd255951079008b364516c"
