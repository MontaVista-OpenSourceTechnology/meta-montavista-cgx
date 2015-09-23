# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"
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
           ${@base_conditional("LTTNG_VERSION", None, "", "lttng-control lttng-viewer", d)} \
"
#           libmtraq \
#          gdbserver \
#          gdb \
#          oprofile \
