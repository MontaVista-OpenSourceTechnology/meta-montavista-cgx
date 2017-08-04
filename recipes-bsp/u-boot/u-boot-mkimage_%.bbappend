PR .= ".1" 
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://find_more_precise_timestamp_difference.patch"

do_compile () {
 	oe_runmake sandbox_defconfig
	sleep 1
 	oe_runmake cross_tools NO_SDL=1
}
