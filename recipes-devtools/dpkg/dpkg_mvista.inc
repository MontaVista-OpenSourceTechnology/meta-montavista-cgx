# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".8"

# If host machine contains older perl (older than v5.10.0), then
# dpkg build fails during configure. So add below lines
# to use perl given by perl-native (this perl is latest newer than v5.10.0).
DEPENDS += " perl-native "
export PERL="${STAGING_BINDIR_NATIVE}/perl-native/perl"

do_compile_append () {
     oe_runmake -C scripts clean
     oe_runmake -C scripts PERL=/usr/bin/perl 
}

do_install_append () {
     install -d ${D}${base_sbindir}
     mv ${D}${sbindir}//start-stop-daemon ${D}${base_sbindir}
     rm -rf  ${D}${sbindir}
     install -d ${D}${sbindir}
     ln -s ../../${base_sbindir}/start-stop-daemon.${PN} ${D}${sbindir}/start-stop-daemon.${PN}
}


inherit update-alternatives

ALTERNATIVE_PRIORITY = "200"
FILES_${PN}-start-stop += "${base_sbindir}/start-stop-daemon.${PN} ${sbindir}/start-stop-daemon.${PN}"
ALTERNATIVE_${PN}-start-stop = "start-stop-daemon"
ALTERNATIVE_LINK_NAME[start-stop-daemon] = "${base_sbindir}/start-stop-daemon"

