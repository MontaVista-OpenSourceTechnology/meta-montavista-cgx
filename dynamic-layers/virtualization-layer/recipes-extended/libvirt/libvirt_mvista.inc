PR .= ".3"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PACKAGECONFIG:remove:mips64 = "qemu"
PACKAGECONFIG:remove_aarchilp32 = "qemu"

inherit multilib_script
MULTILIB_SCRIPTS = "${PN}:${sysconfdir}/libvirt/qemu/networks/default.xml" 
MULTILIB_SCRIPTS += "${PN}-libvirtd:${sysconfdir}/pki/libvirt/private/cakey.pem" 
MULTILIB_SCRIPTS += "${PN}-libvirtd:${sysconfdir}/pki/libvirt/private/clientkey.pem" 
MULTILIB_SCRIPTS += "${PN}-libvirtd:${sysconfdir}/pki/libvirt/private/serverkey.pem" 
MULTILIB_SCRIPTS += "${PN}-libvirtd:${sysconfdir}/pki/libvirt/servercert.pem" 
MULTILIB_SCRIPTS += "${PN}-libvirtd:${sysconfdir}/pki/libvirt/clientcert.pem" 
MULTILIB_SCRIPTS += "${PN}-libvirtd:${sysconfdir}/pki/CA/cacert.pem" 

do_install_ptest:append () {
	# Replace "/tmp" with the resolved symbolic link path i.e
	# "/var/volatile/tmp", to match expected and actual output 
	sed -i "s|CWD:/tmp|CWD:/var/volatile/tmp|g" \
	${D}${PTEST_PATH}/tests/commanddata/test*.log
}
