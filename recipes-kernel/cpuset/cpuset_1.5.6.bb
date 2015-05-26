# Copyright (c) 2012 MontaVista Software LLC.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

require cpuset.inc

PR = "${INC_PR}.5"

SRC_URI += "file://cpuset-fix_python_libpaths.patch \
        file://cpuset-use-cgroups-if-there.patch \
        file://cpuset-add-exclude-pid.patch \
        file://cpuset-cgroup-mounts-omit-ns.patch \
       "

SRC_URI[md5sum] = "50a0251c31990bb4ad63312e356ffcb5"
SRC_URI[sha256sum] = "800d9312bccb5b9802c04661464c6d8f14be8c677f68502e82558c6cb1b03413"

LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"