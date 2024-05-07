# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE.MIT;md5=030cb33d2af49ccebca74d0588b84a21"
DESCRIPTION = "Task for using DevRocket on the target for development"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PR = "r4"

PROVIDES = "task-devrocket"


PACKAGES = "${PN}"
RPROVIDES:${PN} = "task-devrocket"
RPROVIDES:${PN}-dev = "task-devrocket-dev"
RPROVIDES:${PN}-dbg = "task-devrocket-dbg"

RDEPENDS:${PN} = " \
           openssh \
           openssh-sftp-server \
           coreutils \
           file \
           glibc-utils \
           ${@oe.utils.conditional("LTTNG_VERSION", None, "", "lttng-control lttng-viewer", d)} \
           mv-target-daemon \
"
