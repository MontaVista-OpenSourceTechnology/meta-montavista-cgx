require recipes-kernel/linux/linux-yocto.inc

MV_KERNEL_TREE_BRANCH ?= "mvl-3.18/cgx"
MV_KERNEL_TREE_SRCREV ?= "AUTOINC"
MV_KERNEL_TREE ?= "git://${TOPDIR}/sources/linux-mvista-3.18"

SRCREV_machine ?= "${MV_KERNEL_TREE_SRCREV}"
SRCREV ?= "${MV_KERNEL_TREE_SRCREV}"
SRCPV ?= "${MV_KERNEL_TREE_SRCREV}"
BRANCH ?= "${MV_KERNEL_TREE_BRANCH}"

SRC_URI = "${MV_KERNEL_TREE};bareclone=1;branch=${BRANCH},${KMETA};name=machine,meta"

PV = "${LINUX_VERSION}+git${SRCPV}"

KMETA = "meta"

LINUX_KERNEL_TYPE = "standard"

LINUX_VERSION_EXTENSION ?= "-mvista"

COMPATIBLE_MACHINE = "qemuarm|qemuarm64|qemux86|qemuppc|qemumips|qemumips64|qemux86-64"
