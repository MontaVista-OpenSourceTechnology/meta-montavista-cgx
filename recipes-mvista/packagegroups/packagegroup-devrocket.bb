# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"
DESCRIPTION = "Task for using DevRocket on the target for development"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PR = "r4"

PROVIDES = "task-devrocket"


PACKAGES = "${PN}"
RPROVIDES_${PN} = "task-devrocket"
RPROVIDES_${PN}-dev = "task-devrocket-dev"
RPROVIDES_${PN}-dbg = "task-devrocket-dbg"

RDEPENDS_${PN} = " \
           openssh \
           openssh-sftp-server \
           coreutils \
           file \
           glibc-utils \
           ${@oe.utils.conditional("LTTNG_VERSION", None, "", "lttng-control lttng-viewer", d)} \
           mv-target-daemon \
"
#           libmtraq \
#          gdbserver \
#          gdb \
#          oprofile \
