PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://gmp-6.0.0-gmp-h.patch"
TARGET_ARCH_task-configure_linux-gnuilp32 = "none"
