# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".5"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append () {
    # udev service fails to start , when /var/run is symbolic link to
    # /var/volatile/run directory; as /var/volatile/run directory
    # is created (via populate-volatile.sh) after udev script 
    # is executed. So, let udev create control files in non-volatile /run 
    # directory instead of /var/run.
    sed -i 's:^udev_run="/var/run/udev":udev_run="/run":g' ${D}${sysconfdir}/udev/udev.conf
}
