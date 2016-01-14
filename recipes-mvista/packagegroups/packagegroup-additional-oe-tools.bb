
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
	"
RDEPENDS_packagegroup-additional-oe-tools = "\
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
        packagegroup-oe-debug \
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
	drbd \
	smartmontools \
	bootcycle \
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

