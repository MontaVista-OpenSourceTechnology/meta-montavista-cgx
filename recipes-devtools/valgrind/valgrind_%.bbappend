PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://Mask-CPUID-support-in-HWCAP-on-aarch64.patch"

inherit ship-recipe-sources multilib-alternatives
MULTILIB_HEADERS = "valgrind/config.h"
