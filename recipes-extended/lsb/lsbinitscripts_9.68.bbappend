# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#
PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/lsbinitscripts:"

SRC_URI += "file://avoid_invalid_msg_print_on_stderr.patch"

BBCLASSEXTEND = "native"
