# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:${THISDIR}/files:"
SRC_URI += "file://save-baud-rate-1.20.2.patch \
"

