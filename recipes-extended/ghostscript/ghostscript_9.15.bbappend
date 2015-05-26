# Copyright (c) 2012, 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".3"

# Adding bbappend file to include objarch.h file in
# ${FILESEXTRAPATHS} directory.
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/${HOST_ARCH}:"

