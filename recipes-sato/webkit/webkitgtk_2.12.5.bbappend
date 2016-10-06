# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".5"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://add_mips_armeb_options.patch \
            file://check_for_aarch64_and_aarch64_32_bit_variant.patch \
	   "

