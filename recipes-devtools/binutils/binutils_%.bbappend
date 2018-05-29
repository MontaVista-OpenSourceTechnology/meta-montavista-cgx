PR .= ".1"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://objcopy-kgraft.diff"
EXTRA_OEMAKE += "WARN_CFLAGS='-W -Wall -Wstrict-prototypes -Wmissing-prototypes -Wshadow'"
do_configure_prepend_class-target () {
	sed -i ${S}/bfd/warning.m4 -e "/Wstack-usage/D"
	sed -i ${S}/bfd/configure -e "s/-Wstack-usage=262144//"
	sed -i ${S}/binutils/configure -e "s/-Wstack-usage=262144//"
}
