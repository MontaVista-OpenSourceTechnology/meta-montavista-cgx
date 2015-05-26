require recipes-kernel/linux/linux-yocto.inc

SRC_URI = "git://${MVL_MIRROR}/${BPN}-${LINUX_VERSION}.git;protocol=ssh;bareclone=1;branch=${KBRANCH},${KMETA};name=machine,meta"

PV = "${LINUX_VERSION}+git${SRCPV}"

KMETA = "meta"

LINUX_KERNEL_TYPE = "standard"

LINUX_VERSION_EXTENSION ?= "-mvista"

COMPATIBLE_MACHINE = "qemuarm|qemuarm64|qemux86|qemuppc|qemumips|qemumips64|qemux86-64"
