LIBVIRT=" \
        libvirt \
        libvirt-libvirtd \
        libvirt-virsh \
        libvirt-python \
        libvirt-dev \
"
# FIXME libvirt depends on qemu which does not build on mips64
LIBVIRT:qemumips64 = ""
LIBVIRT:qemumips64nfp = ""

RDEPENDS:packagegroup-oe-virtualization:append = " \
	${LIBVIRT} \
"

RDEPENDS:packagegroup-oe-console-utilities:append = " \
	autofs \
"

RDEPENDS:packagegroups-oe-ftpclient:append = " \
        netkit-ftp \
        lftp \
"

RDEPENDS:packagegroups-oe-networkmanagement:append = " \
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
    tgt \
    "
# FIXME: not building
#	traceroute 

RDEPENDS:packagegroups-oe-ftpserver:append = " \
	proftpd \
"

RDEPENDS:packagegroups-oe-mailserver:append = " \
	postfix \
"

RDEPENDS:packagegroup-oe-security:append = " \
	strongswan \
"

RDEPENDS:packagegroup-oe-netprotocol-utilities = " \
	ptpd \
"
