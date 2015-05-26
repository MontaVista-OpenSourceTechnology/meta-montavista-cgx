# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".2"

DEPENDS += "perl-native"

export PERL="${STAGING_BINDIR_NATIVE}/perl-native/perl"

# MD2 is required by ipmiutil
EXTRA_OECONF += 'enable-md2'
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI += "file://crypto-use-bigint-in-x86-64-perl.patch \
           "
