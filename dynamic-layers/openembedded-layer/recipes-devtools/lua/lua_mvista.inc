PR .= ".2"

inherit multilib_header

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://create_shared_liblua_library.patch"
do_install_append () {
	mv ${D}${libdir}/liblua.so ${D}${libdir}/liblua.so.0.0.0
        ln -s liblua.so.0.0.0 ${D}${libdir}/liblua.so
	oe_multilib_header luaconf.h
}
