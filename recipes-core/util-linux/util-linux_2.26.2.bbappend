FILESEXTRAPATHS_append := "${THISDIR}/files"

EXTRA_OECONF_append_class-native = " --disable-libmount --disable-mount --disable-fsck"

SRC_URI_append_class-native = "file://util-linux-defines.diff"
