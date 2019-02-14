PR .= ".4"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://Mask-CPUID-support-in-HWCAP-on-aarch64.patch \
	    file://add-code-to-recognize-armeb.patch"

inherit ship-recipe-sources
