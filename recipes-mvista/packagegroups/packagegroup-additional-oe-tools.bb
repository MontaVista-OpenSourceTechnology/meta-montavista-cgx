
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
	packagegroup-oe-tools-profile-utilities \
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
	packagegroup-oe-tools-profile-utilities \
	"
RDEPENDS_packagegroup-oe-tools-profile-utilities = "${VALGRIND} \
                                                    perf"

VALGRIND = ""
VALGRIND_x86-64 = "valgrind"
VALGRIND_x86-generic-64 = "valgrind"
VALGRIND_i686 = "valgrind"
VALGRIND_mips = "valgrind"
VALGRIND_powerpc = "valgrind"
VALGRIND_powerpc64 = "valgrind"
VALGRIND_armv7a = "valgrind"

RDEPENDS_packagegroup-oe-virtualization = " \
	libvirt \
	"

RDEPENDS_packagegroup-oe-filesystemutilities = "\
	squashfs-tools \
	cpuset \
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
	oprofile \
	pax-utils \
	tiff \
	libunwind \
	guile \
	lvm2 \
	libc-client \
	libol \
        ncurses-tools \
	smartmontools \
	bootcycle \
	vim \
	cdrkit \
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
	strongswan \
	tunctl \
	iscsitarget \
	iscsi-initiator-utils \
	ethtool \
	portmap \
	"

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
	"

