# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://shadow-4.2.1-goodname.patch"

# set maximum length of group name to 32 
EXTRA_OECONF +=" --with-group-name-max-length=32 "

do_install_append () {
	#  Our user group is 100, not 1000
	sed -i 's/^GROUP=1000/GROUP=100/' ${D}${sysconfdir}/default/useradd
}
