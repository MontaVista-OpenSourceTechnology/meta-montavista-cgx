LIBVIRT=" \
        libvirt \
        libvirt-libvirtd \
        libvirt-virsh \
        libvirt-python \
        libvirt-dev \
"
# FIXME libvirt depends on qemu which does not build on mips64
LIBVIRT_qemumips64 = ""
LIBVIRT_qemumips64nfp = ""

RDEPENDS_packagegroup-oe-virtualization_append = " \
	${LIBVIRT} \
"

RDEPENDS_packagegroup-oe-console-utilities_append = " \
	autofs \
"

RDEPENDS_packagegroups-oe-ftpclient_append = " \
        netkit-ftp \
        lftp \
"

RDEPENDS_packagegroups-oe-networkmanagement_append = " \
	sntp \
	radvd \
	tunctl \
	bridge-utils \
	ifenslave \
	netkit-telnet \
	openl2tp \
	quagga \
	${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'quagga-watchquagga', '', d)} \
	quagga-ospfclient \
	strongswan \
	tcpdump \
	lksctp-tools \
	vlan \
	iscsi-initiator-utils \
	traceroute \
"

RDEPENDS_packagegroups-oe-ftpserver_append = " \
	proftpd \
"

RDEPENDS_packagegroups-oe-mailserver_append = " \
	postfix \
"

RDEPENDS_packagegroup-oe-security_append = " \
	strongswan \
        wireshark \
	tshark \
"

RDEPENDS_packagegroup-oe-netprotocol-utilities = " \
	ptpd \
"
