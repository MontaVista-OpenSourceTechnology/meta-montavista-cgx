require recipes-kernel/linux-libc-headers/linux-libc-headers.inc

MV_KERNEL_BRANCH ?= "mvl-4.14/msd.cgx"
MV_KERNEL_TREE ?= "git://github.com/MontaVista-OpenSourceTechnology/linux-mvista-2.4.git;protocol=https"
MV_KERNELCACHE_BRANCH ?= "yocto-4.14"
MV_KERNELCACHE_TREE ?= "git://github.com/MontaVista-OpenSourceTechnology/yocto-kernel-cache;protocol=https"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"
SRCREV ?= "${MV_KERNEL_BRANCH}"

LINUX_VERSION = "4.14"

SRC_URI = "${MV_KERNEL_TREE};branch=${MV_KERNEL_BRANCH}"
S = "${WORKDIR}/git"
