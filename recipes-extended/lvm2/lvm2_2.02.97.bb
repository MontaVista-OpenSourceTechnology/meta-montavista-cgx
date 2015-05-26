# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#
SECTION = "utils"
DESCRIPTION = "LVM2 is a set of utilities to manage logical volumes in Linux."
LICENSE = "GPLv2+"
PR = "r4"
PROVIDES = "device-mapper"

DEPENDS = "udev readline"

SRC_URI = "ftp://sources.redhat.com/pub/lvm2/LVM2.${PV}.tgz \
           file://lvm2.rules \
           file://fix-libdevmapper-pkgconfig.patch \
       file://fix-selinux-link.patch \
       file://lvm2-remove-usr-use.patch"


SRC_URI[md5sum] = "d18bd01334309db1c422b9bf6b181057"
SRC_URI[sha256sum] = "edda82012e8a9e1f0b00ba5a331468d3e0201992be14c0dbea71bf564a51fc2b"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f \
            file://COPYING.LIB;md5=fbc093901857fcd118f065f900982c24"

S = "${WORKDIR}/LVM2.${PV}"

# Unset user/group to unbreak install.
EXTRA_OECONF = "--with-user= --with-group= --disable-o_direct \
        --enable-udev_sync --enable-udev_rules \
        --with-udevdir=/etc/udev/rules.d"
EXTRA_OECONF_append = " --disable-selinux --enable-pkgconfig \
    --with-usrlibdir=${libdir}"
inherit autotools

# For some annoying reason lvm uses CLDFLAGS, not LDFLAGS
EXTRA_OEMAKE = "CLDFLAGS='-L${STAGING_DIR_TARGET}${libdir} \
                         -Wl,-rpath-link,${STAGING_DIR_TARGET}${libdir}'"

TARGET_CC_ARCH += " ${LDFLAGS} "

do_install() {
    autotools_do_install

    # Put the tools in / where the belong
    install -d ${D}${base_sbindir}
    mv ${D}${sbindir}/* ${D}${base_sbindir}/
    rmdir ${D}${sbindir}
    install -d ${D}${base_libdir}/
    mv ${D}${libdir}/lib* ${D}${base_libdir}/

    # Put the shlib .so file in /usr/lib where it belongs
    rm -f ${D}${base_libdir}/libdevmapper.so
    # Just in case, some installs tend to stick it there, even for multilib
    rm -f ${D}/usr/lib/libdevmapper.so
    ln -sf ../..${base_libdir}/libdevmapper.so.1.02 ${D}${libdir}/libdevmapper.so
    for each in ${D}${sysconfdir}/udev/rules.d/*.rules; do 
        sed -i $each -e 's,/usr/sbin/,/sbin/,'
    done
}
