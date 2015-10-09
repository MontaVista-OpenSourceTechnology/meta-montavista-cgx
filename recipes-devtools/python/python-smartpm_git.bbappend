FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_class-target = "file://ignore-archscore.diff"
SRC_URI_append_class-native = "file://ignore-archscore-native.diff"


PR .= ".4"
