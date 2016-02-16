require recipes-kernel/linux/linux-mvista.inc

MV_KERNEL_TREE_BRANCH ?= "mvl-4.1/cgx"
MV_KERNEL_TREE_SRCREV ?= "${AUTOREV}"
MV_KERNEL_TREE ?= "git://${TOPDIR}/sources/linux-mvista-4.1"

SRCREV_machine_mvista-cgx ?= "${MV_KERNEL_TREE_SRCREV}"
SRCREV_mvista-cgx ?= "${MV_KERNEL_TREE_SRCREV}"
SRCPV_mvista-cgx ?= "${MV_KERNEL_TREE_SRCREV}"
BRANCH_mvista-cgx ?= "${MV_KERNEL_TREE_BRANCH}"

SRC_URI = " \ 
           file://defconfig \
           ${MV_KERNEL_TREE};branch=${BRANCH};name=machine \
"

PV = "${LINUX_VERSION}+git${SRCPV}"

KMETA = "meta"

LINUX_KERNEL_TYPE = "standard"

LINUX_VERSION_EXTENSION ?= "-mvista"
KCONFIG_MODE = "--alldefconfig"

COMPATIBLE_MACHINE = "qemuarm|qemuarm64|qemux86|qemuppc|qemumips|qemumips64|qemux86-64"
