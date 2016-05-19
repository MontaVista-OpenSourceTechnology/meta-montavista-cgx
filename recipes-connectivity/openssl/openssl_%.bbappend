# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".3"

DEPENDS += "perl-native"

export PERL="${STAGING_BINDIR_NATIVE}/perl-native/perl"

# MD2 is required by ipmiutil
EXTRA_OECONF += 'enable-md2'
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

#Adding big int causes build failures on older assemblers.
SRC_URI_remove_class-native = "file://crypto_use_bigint_in_x86-64_perl.patch"
