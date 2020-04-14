MV_KERNEL_BRANCH ?= "mvl-5.4/msd.cgx"
MV_KERNEL_TREE ?= "git://github.com/MontaVista-OpenSourceTechnology/linux-mvista"
KBRANCH ?= "${MV_KERNEL_BRANCH}"

require recipes-kernel/linux/linux-yocto.inc
NO_SOURCE_MIRROR="1"
BB_GENERATE_MIRROR_TARBALLS = "0"
SRCREV_machine ?= "${MV_KERNEL_BRANCH}"
SRCREV_meta ?= "eda4d18ce4b259c84ccd5c249c3dc5958c16928c"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

SRC_URI = "${MV_KERNEL_TREE};name=machine;branch=${KBRANCH}; \
           https://github.com/MontaVista-OpenSourceTechnology/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-5.4;destsuffix=${KMETA}"

LINUX_VERSION ?= "4.19"

PV = "${LINUX_VERSION}+git${SRCPV}"

KMETA = "kernel-meta"
KCONF_BSP_AUDIT_LEVEL = "2"

KERNEL_DEVICETREE_qemuarm = "versatile-pb.dtb"
COMPATIBLE_MACHINE = "null"
COMPATIBLE_MACHINE_qemuarm = "qemuarm"
COMPATIBLE_MACHINE_qemuarm64 = "qemuarm64"
COMPATIBLE_MACHINE_qemux86 = "qemux86"
COMPATIBLE_MACHINE_qemuppc = "qemuppc"
COMPATIBLE_MACHINE_qemumips = "qemumips"
COMPATIBLE_MACHINE_qemumips64 = "qemumips64"
COMPATIBLE_MACHINE_qemux86-64 = "qemux86-64"
KERNEL_FEATURES_remove_qemuall = "features/kernel-sample/kernel-sample.scc"

DEPENDS += "elfutils-native"

# Functionality flags
KERNEL_EXTRA_FEATURES ?= "features/netfilter/netfilter.scc"
KERNEL_FEATURES_append = " ${KERNEL_EXTRA_FEATURES}"
KERNEL_FEATURES_append_qemuall=" cfg/virtio.scc"
KERNEL_FEATURES_append_qemux86=" cfg/sound.scc cfg/paravirt_kvm.scc"
KERNEL_FEATURES_append_qemux86-64=" cfg/sound.scc cfg/paravirt_kvm.scc"
KERNEL_FEATURES_append = " ${@bb.utils.contains("TUNE_FEATURES", "mx32", " cfg/x32.scc", "" ,d)}"
