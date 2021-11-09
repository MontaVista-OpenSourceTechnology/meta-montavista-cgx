PR .= ".3"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PACKAGECONFIG:remove:mips64 = "qemu"
PACKAGECONFIG:remove_aarchilp32 = "qemu"

inherit multilib_script
MULTILIB_SCRIPTS = "${PN}:${sysconfdir}/libvirt/qemu/networks/default.xml" 

do_install_ptest:append () {
	# Replace "/tmp" with the resolved symbolic link path i.e
	# "/var/volatile/tmp", to match expected and actual output 
	sed -i "s|CWD:/tmp|CWD:/var/volatile/tmp|g" \
	${D}${PTEST_PATH}/tests/commanddata/test*.log
}
