require recipes-kernel/linux-libc-headers/linux-libc-headers.inc

MV_KERNEL_BRANCH ?= "mvl-4.19/msd.cgx"
MV_KERNEL_TREE ?= "git://github.com/MontaVista-OpenSourceTechnology/linux-mvista-2.6.git;protocol=https"
MV_KERNELCACHE_BRANCH ?= "yocto-4.19"
MV_KERNELCACHE_TREE ?= "git://github.com/MontaVista-OpenSourceTechnology/yocto-kernel-cache;protocol=https"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"
SRCREV ?= "${MV_KERNEL_BRANCH}"

LINUX_VERSION = "4.19"

SRC_URI = "${MV_KERNEL_TREE};branch=${MV_KERNEL_BRANCH}"
S = "${WORKDIR}/git"
