# Copyright (c) 2010, 2011, 2012, 2013 MontaVista Software LLC.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

DESCRIPTION = "Linux Containers (LXC) provides the ability to group and isolate of a set of processes in a jail by virtualizing and accounting kernel resources."
HOMEPAGE = "http://lxc.sourceforge.net"
SECTION = "console/utils"
PRIORITY = "optional"
LICENSE = "GPLv2"
DEPENDS = "virtual/kernel libcap docbook-sgml-dtd-3.0-native docbook-utils-native lsb-native"
# Coreutils is here becase the busybox cp won't work
# util-linux supplies getopt
RDEPENDS_${PN} = "bridge-utils coreutils openssh util-linux gzip"
RRECOMMENDS_${PN} = "libcap"
INC_PR = "r14"

SRC_URI = "http://lxc.sourceforge.net/download/lxc/lxc-${PV}.tar.gz \
       file://lxc-mvlinux"

inherit autotools

FILES_${PN} += "${localstatedir}"
FILES_${PN}-dbg += "${libdir}/lxc/lxc/.debug"
