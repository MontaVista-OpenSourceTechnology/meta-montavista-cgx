
#
# Copyright (C) 2014 Montavista Inc
#

SUMMARY = "Additional packages"
DESCRIPTION = "Additional packages for cge complete image"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
        packagegroup-additional-oe-tools \
	packagegroup-oe-filesystemutilities \
	packagegroup-oe-hotplugutilities \
	packagegroup-oe-wirelessutilities \
	packagegroup-oe-console-utilities \
	packagegroups-oe-networkmanagement \
	packagegroups-oe-logmanagement \
	packagegroups-oe-ftpserver \
	packagegroups-oe-ftpclient \
	packagegroups-oe-mailclient \
	packagegroups-oe-mailserver \
	packagegroup-oe-graphics \
	packagegroup-oe-security \
        packagegroup-oe-debug  \
	packagegroup-oe-webserver \
        packagegroup-oe-virtualization  \
        packagegroup-oe-database-utilities  \
        packagegroup-oe-netprotocol-utilities \
        packagegroup-oe-test-tools \
        packagegroup-oe-extra-dev-libraries \
	"

RDEPENDS_packagegroup-additional-oe-tools = "\
	packagegroup-oe-filesystemutilities \
	packagegroup-oe-hotplugutilities \
	packagegroup-oe-wirelessutilities \
	packagegroup-oe-console-utilities \
	packagegroups-oe-networkmanagement \
	packagegroups-oe-logmanagement \
	packagegroup-core-ssh-openssh \
	packagegroups-oe-ftpserver \
	packagegroups-oe-ftpclient \
	packagegroups-oe-mailclient \
	packagegroups-oe-mailserver \
	packagegroup-oe-graphics \
	packagegroup-oe-security \
        packagegroup-oe-debug \
	packagegroup-oe-webserver \
	packagegroup-oe-virtualization \
	packagegroup-core-tools-profile \
	packagegroup-oe-database-utilities \
        packagegroup-oe-netprotocol-utilities \
        packagegroup-oe-test-tools \
        packagegroup-oe-extra-dev-libraries \
	"

LIBVIRT=" \
        libvirt \
        libvirt-libvirtd \
        libvirt-virsh \
        libvirt-python \
"
#libvirt depends on a package that depends on mozjs which is not working right now.
#FIXME
LIBVIRT=""
# FIXME libvirt depends on qemu which does not build on mips64
LIBVIRT_qemumips64 = ""
LIBVIRT_qemumips64nfp = ""


RDEPENDS_packagegroup-oe-virtualization = " \
	${LIBVIRT} \
	lua \
"

RDEPENDS_packagegroup-oe-filesystemutilities = "\
	squashfs-tools \
	python-cpuset \
	cramfs \
	stat \
        util-linux-fsck \
	"

RDEPENDS_packagegroup-oe-hotplugutilities = "\
	pcmciautils \
	usbutils \
	"
RDEPENDS_packagegroup-oe-wirelessutilities = "\
	irda-utils \
	"
OPROFILE="oprofile"
OPROFILE_linux-gnuilp32 = "" 
#Fix Me: This should work
OPROFILE_linux-gnun32 = "" 
RDEPENDS_packagegroup-oe-console-utilities = "\
	autofs \
	console-tools \
	cups \
	dosfstools \
	dtc \ 
	libcgroup \
	libgcc \
	run-postinsts \
	stat \
	linux-firmware \
	mtd-utils \
	${OPROFILE} \
	pax-utils \
	tiff \
	libunwind \
	lvm2 \
	libc-client \
	libol \
        ncurses-tools \
	smartmontools \
	bootcycle \
	vim \
	cdrkit \
	glibc-scripts \
	glibc-gconv-utf-16 \
	udev-extraconf \
	postgresql \
	postgresql-client \
	postgresql-timezone \
	multipath-tools \
	poco \
"

RDEPENDS_packagegroup-oe-extra-dev-libraries = "\
        poco \
"

RDEPENDS_packagegroup-oe-database-utilities ="\
	mariadb-setupdb \
	mariadb-client \
	mariadb-server \
	libmysqlclient \
"

RDEPENDS_packagegroups-oe-networkmanagement ="\
	ntp \
	radvd \
	tunctl \
	gnupg \
	bridge-utils \
	ifenslave \
	libcap-ng \
	netkit-telnet \
	openl2tp \
	openldap \
	quagga \
        ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'quagga-watchquagga', '', d)} \
	quagga-ospfclient \
	strongswan \
	tunctl \
	ethtool \
	net-tools \
	dhcp-client \
	dhcp-server \
	tcpdump \
        lksctp-tools \
        tipcutils \
        tipcutils-demos \
        vlan \
	sg3-utils \
	sg3-utils-udev \
	${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'iscsi-initiator-utils', '', d)} \
	traceroute \	
"
#FIXME
#	portmap 
#	iscsitarget 

RDEPENDS_packagegroups-oe-logmanagement ="\
	syslog-ng \
	consolekit \
	pam-plugin-ck-connector \
	"
RDEPENDS_packagegroups-oe-ftpserver ="\
	proftpd \
	"

RDEPENDS_packagegroups-oe-ftpclient ="\
        netkit-ftp \
        lftp \
	"

RDEPENDS_packagegroups-oe-mailclient ="\
	mailx \
	"
RDEPENDS_packagegroups-oe-mailserver ="\
	postfix \
        "

RDEPENDS_packagegroup-oe-graphics = "\
	encodings \
	font-util \
 	libdmx \
	libfontenc \
	libmatchbox\
	libgcc \
	libxcalibrate \
	libxfont \ 
	libxkbfile \
	libxres  \ 
	libxvmc \ 
	libxxf86dga \ 
	libxxf86misc \
	mkfontdir \ 
	mkfontscale \ 
	matchbox-desktop \
	startup-notification \ 
	xauth \
	xdpyinfo \
	xev \ 
	xeyes  \ 
	xinit \ 
	xmodmap \
        xserver-xf86-config \
	xrandr \ 
	xset \ 
	xvinfo  \ 
	libxpm \
	"

RDEPENDS_packagegroup-oe-webserver =" \
        apache2 \
	"

DEPENDS += "rsyslog nginx"

RDEPENDS_packagegroup-oe-console-utils += "${X86_PACKAGES_OE_CONSOLE_UTILS}"

X86_PACKAGES_OE_CONSOLE_UTILS = ""

X86_PACKAGES_OE_CONSOLE_UTILS_x86-64 = " \
  grub \
  ruby \
  nasm \
  efibootmgr \
  gnu-efi \
	"

X86_PACKAGES_OE_CONSOLE_UTILS_i686 = " \
  grub \
  ruby \
  nasm \
  efibootmgr \
  gnu-efi \
	"

RDEPENDS_packagegroup-oe-security = "\
	cyrus-sasl \
	ipsec-tools \
	liblockfile \
	lockfile-progs \
	pinentry \
	wireshark \
	"

RDEPENDS_packagegroup-oe-debug = "\
	gdb-kdump-helpers \
	libunwind \
	kdump-elftool \
	"

RDEPENDS_packagegroup-oe-netprotocol-utilities = " \
	ptpd \
"

RDEPENDS_packagegroup-oe-test-tools = " \
        rt-tests \
        python-pip \
"
