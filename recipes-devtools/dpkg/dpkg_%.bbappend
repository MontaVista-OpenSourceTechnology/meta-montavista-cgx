# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".7"

# If host machine contains older perl (older than v5.10.0), then
# dpkg build fails during configure. So add below lines
# to use perl given by perl-native (this perl is latest newer than v5.10.0).
DEPENDS += " perl-native "
export PERL="${STAGING_BINDIR_NATIVE}/perl-native/perl"

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

