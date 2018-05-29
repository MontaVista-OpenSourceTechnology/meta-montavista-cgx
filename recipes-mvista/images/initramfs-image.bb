# Simple initramfs image.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first “init” program more efficiently."

IMAGE_INSTALL = "packagegroup-core-boot kmod initramfs-module-block initramfs-module-loop initramfs-module-nfs"

PACKAGE_REMOVE = "kernel-image-* update-modules"
IMAGE_FEATURES = ""

export IMAGE_BASENAME = "initramfs-image"
IMAGE_LINGUAS = " "

LICENSE = "MIT"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit core-image

IMAGE_ROOTFS_SIZE = "8192"

BAD_RECOMMENDATIONS += "busybox-syslog"
