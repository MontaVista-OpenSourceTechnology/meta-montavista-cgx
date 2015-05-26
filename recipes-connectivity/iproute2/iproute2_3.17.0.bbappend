# Copyright (c) 2012,2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"
# This patch is broken and needs to be reworked for current version
#SRC_URI += "file://0001-Add-ip-netns-get-to-get-a-processes-network-namespac.patch"
