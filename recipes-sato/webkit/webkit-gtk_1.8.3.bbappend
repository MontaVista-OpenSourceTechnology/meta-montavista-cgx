# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".5"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://mips-webkit.patch \
            file://add_armeb_arch_support.patch \
            file://check_for_aarch64_32_bit_variant.patch"

