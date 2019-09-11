PR .= ".3"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGECONFIG_remove_mips64 = "qemu"
PACKAGECONFIG_remove_aarchilp32 = "qemu"

inherit multilib_script
MULTILIB_SCRIPTS = "${PN}:${sysconfdir}/libvirt/qemu/networks/default.xml" 

do_install_ptest_append () {
	# Replace "/tmp" with the resolved symbolic link path i.e
	# "/var/volatile/tmp", to match expected and actual output 
	sed -i "s|CWD:/tmp|CWD:/var/volatile/tmp|g" \
	${D}${PTEST_PATH}/tests/commanddata/test*.log
}
