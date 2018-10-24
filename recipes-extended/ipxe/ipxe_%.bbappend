FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-No-need-for-workaround-for-host-cc.patch;striplevel=2"

EXTRA_OEMAKE+= "HOST_CFLAGS='-I${STAGING_INCDIR_NATIVE} -L${STAGING_LIBDIR_NATIVE}'"
