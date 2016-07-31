# Copyright (c) 2010,2012 MontaVista Software LLC.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

DESCRIPTION = "Python application to make using the cpusets \
           facilities in the Linux kernel easier."
HOMEPAGE = "http://code.google.com/p/cpuset"
SECTION = "console/utils"
PRIORITY = "optional"
LICENSE = "LGPLv2+"
DEPENDS = "python-native"
RDEPENDS_${PN} = "python-textutils python-logging python-re python-unixadmin"
INC_PR = "r7"

SRC_URI = "http://cpuset.googlecode.com/files/cpuset-${PV}.tar.gz"

inherit distutils

B="${S}"

do_configure_prepend () {
    sed -e "s,in\ doc\ t,in doc," -i ${S}/Makefile
}

do_compile() {
    BUILD_SYS="${BUILD_SYS}" HOST_SYS="${HOST_SYS}" \
    PREFIX="${prefix}"				\
        oe_runmake
}

do_install() {
    BUILD_SYS="${BUILD_SYS}" HOST_SYS="${HOST_SYS}" \
    STAGING_LIBDIR="${STAGING_LIBDIR}"		\
    STAGING_INCDIR="${STAGING_INCDIR}"		\
    PREFIX="${prefix}" DESTDIR="${D}"		\
        oe_runmake install
}

FILES_${PN} += "${libdir}/${PYTHON_DIR}"
