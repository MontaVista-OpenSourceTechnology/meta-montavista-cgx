MV_KERNEL_BRANCH ?= "mvl-5.4/msd.cgx"
MV_KERNEL_TREE ?= "git://github.com/MontaVista-OpenSourceTechnology/linux-mvista"
MV_KERNELCACHE_BRANCH ?= "yocto-5.4"
MV_KERNELCACHE_TREE ?= "git://github.com/MontaVista-OpenSourceTechnology/yocto-kernel-cache;protocol=https"

KBRANCH ?= "${MV_KERNEL_BRANCH}"

require recipes-kernel/linux/linux-yocto.inc
NO_SOURCE_MIRROR="1"
BB_GENERATE_MIRROR_TARBALLS = "0"
SRCREV_machine ?= "${MV_KERNEL_BRANCH}"
SRCREV_meta ?= "eda4d18ce4b259c84ccd5c249c3dc5958c16928c"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

SRC_URI = "${MV_KERNEL_TREE};branch=${MV_KERNEL_BRANCH};name=machine \
           ${MV_KERNELCACHE_TREE};type=kmeta;name=meta;branch=${MV_KERNELCACHE_BRANCH};destsuffix=${KMETA}"

LINUX_VERSION ?= "5.4"

PV = "${LINUX_VERSION}+git${SRCPV}"

KMETA = "kernel-meta"
KCONF_BSP_AUDIT_LEVEL = "2"

KERNEL_DEVICETREE:qemuarm = "versatile-pb.dtb"
COMPATIBLE_MACHINE = "null"
COMPATIBLE_MACHINE:qemuarm = "qemuarm"
COMPATIBLE_MACHINE:qemuarm64 = "qemuarm64"
COMPATIBLE_MACHINE:qemux86 = "qemux86"
COMPATIBLE_MACHINE:qemuppc = "qemuppc"
COMPATIBLE_MACHINE:qemumips = "qemumips"
COMPATIBLE_MACHINE:qemumips64 = "qemumips64"
COMPATIBLE_MACHINE:qemux86-64 = "qemux86-64"
KERNEL_FEATURES:remove:qemuall = "features/kernel-sample/kernel-sample.scc"

DEPENDS += "elfutils-native"

# Functionality flags
KERNEL_EXTRA_FEATURES ?= "features/netfilter/netfilter.scc"
KERNEL_FEATURES:append = " ${KERNEL_EXTRA_FEATURES}"
KERNEL_FEATURES:append:qemuall=" cfg/virtio.scc"
KERNEL_FEATURES:append:qemux86=" cfg/sound.scc cfg/paravirt_kvm.scc"
KERNEL_FEATURES:append:qemux86-64=" cfg/sound.scc cfg/paravirt_kvm.scc"
KERNEL_FEATURES:append = " ${@bb.utils.contains("TUNE_FEATURES", "mx32", " cfg/x32.scc", "" ,d)}"
