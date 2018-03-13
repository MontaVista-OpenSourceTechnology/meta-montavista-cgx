SUMMARY = "Distributed block device driver for Linux"
DESCRIPTION = "DRBD is a block device which is designed to build high \
               availability clusters. This is done by mirroring a whole \
               block device via (a dedicated) network. You could see \
               it as a network raid-1."
HOMEPAGE = "http://oss.linbit.com/drbd/"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=5574c6965ae5f583e55880e397fbb018"
DEPENDS = "virtual/kernel"

SRC_URI = "http://www.linbit.com/downloads/drbd/9.0/drbd-${PV}.tar.gz \
           file://check_existence_of_modules_before_installing.patch"

SRC_URI[md5sum] = "2742a97b68dcc12c843e0b1aa52da0f6"
SRC_URI[sha256sum] = "f3577d701ef8d2ea15a149e408a2b83d410596196f53eca50368799d5069b975"
inherit module

EXTRA_OEMAKE += "KDIR='${STAGING_KERNEL_DIR}' HOSTCC='gcc -I${STAGING_INCDIR_NATIVE} \
                 -L${STAGING_DIR_NATIVE}/usr/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/usr/lib \
		 -L${STAGING_DIR_NATIVE}/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/lib'"

do_compile_prepend () {
	export SKIP_STACK_VALIDATION=1
}
do_install () {
    oe_runmake install DESTDIR="${D}"
}
