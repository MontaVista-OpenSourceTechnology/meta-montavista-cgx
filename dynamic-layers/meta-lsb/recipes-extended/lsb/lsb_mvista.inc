# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#
PR .= ".5"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Adding these files, as we may need to add 
# few extra functions for initscripts
SRC_URI += "file://lsb_killproc \
            file://lsb_log_message \
            file://lsb_pidofproc \
            file://lsb_start_daemon \
            file://init-functions \
	    "
RDEPENDS:${PN} += " lsbinitscripts"
RDEPENDS:${PN}_virtclass-native = ""

DEPENDS += "bash"
RDEPENDS:${PN} += "bash"

do_install_virtclass-native() {
	oe_runmake install prefix=${D}${prefix} mandir=${D}/${datadir}/man/ DESTDIR=${D}
}

do_install:append:class-target () {
    install -d ${D}/${datadir}/${PN}
    mv ${D}/${datadir}/man ${D}/${datadir}/${PN}/
}
inherit multilib_script
MULTILIB_SCRIPTS += "${PN}:${sysconfdir}/lsb-release"

FILES:${PN}-doc += "${datadir}/${PN}/man"
BBCLASSEXTEND = "native"

