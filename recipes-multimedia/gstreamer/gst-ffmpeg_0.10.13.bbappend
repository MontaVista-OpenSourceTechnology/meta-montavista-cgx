# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"
SRC_URI += "file://cross-prefix-plus-remove-asm-redunduncy.patch"
 
do_configure_prepend() {
   export TARGET_CC_ARCH="${TARGET_CC_ARCH}"
   export TARGET_LD_ARCH="${TARGET_LD_ARCH}"
   export TARGET_PREFIX="${TARGET_PREFIX}"
}
