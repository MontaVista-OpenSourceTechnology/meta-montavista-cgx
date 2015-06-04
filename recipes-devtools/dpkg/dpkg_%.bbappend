# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".6"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://fix_error_with_older_perl.patch"

PACKAGES =+ "start-stop-daemon"
FILES_start-stop-daemon = "${base_sbindir}/start-stop-daemon.${PN}"

do_install_append () {

     install -d ${D}${base_sbindir}
     mv ${D}${sbindir}//start-stop-daemon ${D}${base_sbindir}
}


RDEPENDS_${PN} += "start-stop-daemon"

inherit update-alternatives

ALTERNATIVE_PRIORITY = "200"

ALTERNATIVE_start-stop-daemon = "start-stop-daemon"
ALTERNATIVE_LINK_NAME[start-stop-daemon] = "${base_sbindir}/start-stop-daemon"

