# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".6"

DEPENDS += "flex-native"

SET_ARCH_FOR_ARM := ""
SET_ARCH_FOR_ARM_armv6 := " ARM_ARCH="6" "
EXTRA_OEMAKE += '\
		${SET_ARCH_FOR_ARM} \
		CC="${CC} ${CFLAGS} ${TARGET_LDFLAGS} -fPIC" \
		'

