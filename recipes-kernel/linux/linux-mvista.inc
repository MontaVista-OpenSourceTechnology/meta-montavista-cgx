require recipes-kernel/linux/linux-yocto.inc

BRANCH ?= "mvl-3.18/cgx"
SRC_URI = "${MV_KERNEL_TREE};bareclone=1;branch=${BRANCH},${KMETA};name=machine,meta"

PV = "${LINUX_VERSION}+git${SRCPV}"

KMETA = "meta"

LINUX_KERNEL_TYPE = "standard"

LINUX_VERSION_EXTENSION ?= "-mvista"

COMPATIBLE_MACHINE = "qemuarm|qemuarm64|qemux86|qemuppc|qemumips|qemumips64|qemux86-64"
