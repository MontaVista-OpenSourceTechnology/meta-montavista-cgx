# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#
# We have a separate version of lvm2, just libdevmapper, really, for use with
# selinux.  We do this because several other packages using libdevmapper do
# not properly add -lselinux, so they won't compile against -ldevmapper.
# The strategy is to supply a non-selinux version of libdevmapper in the
# main package, do normal linking against that, and then add this package
# to enable selinux support.

SECTION = "utils"
DESCRIPTION = "SELinux-specific LVM2 files."
LICENSE = "GPL"
PR = "r2"
RDEPENDS_${PN} = "lvm2"

DEPENDS = "udev readline libselinux"

SRC_URI = "ftp://sources.redhat.com/pub/lvm2/LVM2.${PV}.tgz \
           file://fix-libdevmapper-pkgconfig.patch \
       file://fix-selinux-link.patch"

SRC_URI[md5sum] = "d18bd01334309db1c422b9bf6b181057"
SRC_URI[sha256sum] = "edda82012e8a9e1f0b00ba5a331468d3e0201992be14c0dbea71bf564a51fc2b"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f \
            file://COPYING.LIB;md5=fbc093901857fcd118f065f900982c24"

S = "${WORKDIR}/LVM2.${PV}"
# Unset user/group to unbreak install.
EXTRA_OECONF = "--with-user= --with-group= --disable-o_direct \
        --enable-udev_sync --enable-udev_rules \
            --with-usrlibdir=${libdir} --enable-pkgconfig \
        --with-udevdir=/etc/udev/rules.d"
inherit autotools

# For some annoying reason lvm uses CLDFLAGS, not LDFLAGS
EXTRA_OEMAKE = "CLDFLAGS='-L${STAGING_DIR_TARGET}${libdir} \
                         -Wl,-rpath-link,${STAGING_DIR_TARGET}${libdir}'"

do_install() {
    # Get rid of everything but libdevmapper, which is the only thing
    # that depends on selinux.
    mkdir -p ${WORKDIR}/keep
    autotools_do_install
    mv ${D}${libdir}/libdevmapper.so.1.02 ${WORKDIR}/keep
    mv ${D}${libdir}/pkgconfig/devmapper.pc ${WORKDIR}/keep
    rm -rf ${D}/*
    install -d ${D}/${base_libdir}
    install -d ${D}/${libdir}/pkgconfig
    mv ${WORKDIR}/keep/libdevmapper.so.1.02 ${D}${base_libdir}/libdevmapper.so.1.02.${PN}
    mv ${WORKDIR}/keep/devmapper.pc ${D}${libdir}/pkgconfig/devmapper.pc.${PN}
    rmdir ${WORKDIR}/keep
}

# Turn off debian renaming and soname handlinge.  Otherwise we end up
# with packages named libdevmapper*, and we turn of soname handling
# because we don't really want this package to do anything special with
# respect to sonames, since we are replacing a library.
AUTO_LIBNAME_PKGS = ""
PRIVATE_LIBS = "libdevmapper.so.1.02-${PN}"

pkg_postinst_${PN} () {
        for i in libdevmapper.so.1.02; do
        update-alternatives --install ${base_libdir}/$i $i $i.${PN} 200
    done
}

pkg_postinst_${PN}-dev () {
        for i in devmapper.pc; do
        update-alternatives --install ${libdir}/pkgconfig/$i $i $i.${PN} 200
    done
}

pkg_prerm_${PN} () {
        for i in libdevmapper.so.1.02; do
        update-alternatives --remove $i $i.${PN}
    done
}

pkg_prerm_${PN}-dev () {
        for i in devmapper.pc; do
        update-alternatives --remove $i $i.${PN}
    done
}
