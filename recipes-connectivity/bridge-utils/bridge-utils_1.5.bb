# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

require bridge-utils.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=f9d20a453221a1b7e32ae84694da2c37"

SRC_URI[md5sum] = "ec7b381160b340648dede58c31bb2238"
SRC_URI[sha256sum] = "42f9e5fb8f6c52e63a98a43b81bd281c227c529f194913e1c51ec48a393b6688"

SRC_URI += "file://sysfs_fixes.patch;apply=yes"

PR = "${INC_PR}.2"
