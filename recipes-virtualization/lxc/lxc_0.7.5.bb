# Copyright (c) 2012 MontaVista Software LLC.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

require lxc.inc

SRC_URI += "file://fix-pkglib-programs.patch \
        file://add-mips.patch \
        file://remove-rpath-setting.patch \
        file://lxc-delete-veth-on-err.patch \
        file://lxc-mount-cgroup-automatically.patch \
        file://lxc-cross_compile_fixes.patch \
        file://lxc_configure-container-architecture.patch \
            file://lxc-dont_recreate_vlan_or_phys_interface.patch \
        file://lxc-change-cgroup-mount-detector.patch \
       "

PR = "${INC_PR}.10"

# Include ${STAGING_KERNEL_DIR}/include/uapi also, as UAPI header split changes
# has been taken from kernel 3.7 release
LXC_ISYSTEM = "${STAGING_KERNEL_DIR}/include/uapi -isystem ${STAGING_KERNEL_DIR}/include"
CFLAGS =+ "-isystem ${LXC_ISYSTEM} "
CPPFLAGS =+ "-isystem ${LXC_ISYSTEM} "

do_install_append() {
    install -D -m755 -d "${D}/${localstatedir}/lib/lxc"
    install -m755 ${WORKDIR}/lxc-mvlinux "${D}/${libdir}/lxc/templates"
}

SRC_URI[md5sum] = "04949900ff56898f4353b130929c09d1"
SRC_URI[sha256sum] = "019ec63f250c874bf7625b1f1bf555b1a6e3a947937a4fca73100abddf829b1c"

LIC_FILES_CHKSUM = "file://COPYING;md5=fbc093901857fcd118f065f900982c24"
