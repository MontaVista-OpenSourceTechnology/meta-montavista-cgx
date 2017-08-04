require recipes-kernel/linux/linux-mvista.inc

MV_KERNEL_TREE_BRANCH ?= "mvl-4.1/msd.cgx"
MV_KERNEL_TREE_SRCREV ?= "${AUTOREV}"
MV_KERNEL_TREE ?= "git://${TOPDIR}/sources/linux-mvista-2.0"

SRCREV_machine_mvista-cgx ?= "${MV_KERNEL_TREE_SRCREV}"
SRCREV_mvista-cgx ?= "${MV_KERNEL_TREE_SRCREV}"
SRCPV_mvista-cgx ?= "${MV_KERNEL_TREE_SRCREV}"
BRANCH_mvista-cgx ?= "${MV_KERNEL_TREE_BRANCH}"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-mvista:"

SRC_URI = " \ 
           file://defconfig \
           ${MV_KERNEL_TREE};branch=${BRANCH};name=machine \
"

PV = "${LINUX_VERSION}+git${SRCPV}"

KMETA = "meta"

LINUX_KERNEL_TYPE = "standard"

LINUX_VERSION_EXTENSION ?= "-mvista"
KCONFIG_MODE = "--alldefconfig"

FILESEXTRAPATHS_prepend := "${KERNEL_CFG_LOCATION}:"
SRC_URI += "${@appendKernelCfgFiles(d)}"

# FIXME Need to deal with scc files
KERNEL_FEATURES_remove ="features/debug/printk.scc"
COMPATIBLE_MACHINE = "qemuarm|qemuarm64|qemux86|qemuppc|qemumips|qemumips64|qemux86-64"

# Don't remove debug and comment sections of AArch64 kernel modules
INHIBIT_PACKAGE_STRIP_aarch64 = "1"
