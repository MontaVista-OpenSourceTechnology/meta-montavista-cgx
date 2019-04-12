
#
# Copyright (C) 2014 Montavista Inc
#

SUMMARY = "Additional packages"
DESCRIPTION = "Additional packages for cge complete image"
PR = "r1"
LICENSE = "MIT"

PACKAGE_ARCH = "${MACHINE_ARCH}"

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

RDEPENDS_packagegroup-oe-filesystemutilities = "\
	squashfs-tools \
	cramfs \
"

RDEPENDS_packagegroup-oe-hotplugutilities = "\
	usbutils \
"

RDEPENDS_packagegroup-oe-wirelessutilities = "\
	irda-utils \
"
PREFERRED_PROVIDER_libunwind_toolchain-gcc = "libunwind"
RDEPENDS_packagegroup-oe-console-utilities = " \
	console-tools \
	cups \
	dosfstools \
	dtc \ 
	libcgroup \
	libgcc \
	run-postinsts \
	${@["","linux-firmware"][(d.getVar("MACHINE_EXTRA_RRECOMMENDS").find("linux-firmware") == -1)]} \
	mtd-utils \
	tiff \
	${PREFERRED_PROVIDER_libunwind} \
        ncurses-tools \
	bootcycle \
	glibc-scripts \
	glibc-gconv-utf-16 \
	udev-extraconf \
	util-linux-hwclock \
	u-boot-mkimage \
"

RDEPENDS_packagegroups-oe-networkmanagement = " \
	gnupg \
	libcap-ng \
	ethtool \
	net-tools \
	dhcp-client \
	dhcp-server \
"
RDEPENDS_packagegroups-oe-logmanagement = " \
	consolekit \
	pam-plugin-ck-connector \
"

RDEPENDS_packagegroup-core-ssh-openssh = " \
"

RDEPENDS_packagegroups-oe-ftpserver = " \
"
RDEPENDS_packagegroups-oe-ftpclient = " \
"

RDEPENDS_packagegroups-oe-mailclient = " \
"
RDEPENDS_packagegroups-oe-mailserver = " \
"

RDEPENDS_packagegroup-oe-graphics = " \
	encodings \
	font-util \
 	libdmx \
	libfontenc \
	libmatchbox \
	libgcc \
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

RDEPENDS_packagegroup-oe-webserver = " \
"

RDEPENDS_packagegroup-oe-console-utils += "${X86_PACKAGES_OE_CONSOLE_UTILS}"

X86_PACKAGES_OE_CONSOLE_UTILS = ""

X86_PACKAGES_OE_CONSOLE_UTILS_x86-64 = " \
	grub \
	ruby \
	nasm \
	gnu-efi \
"

X86_PACKAGES_OE_CONSOLE_UTILS_i686 = " \
	grub \
	ruby \
	nasm \
	gnu-efi \
"

RDEPENDS_packagegroup-oe-security = " \
	pinentry \
"
# FIXME Does not build with latest update
#	wireshark 
KDUMP="kdump-elftool"
KDUMP_riscv = ""
KDUMP_riscv64 = ""

RDEPENDS_packagegroup-oe-debug = " \
	gdb-kdump-helpers \
	${PREFERRED_PROVIDER_libunwind} \
	${KDUMP} \
"

RDEPENDS_packagegroup-oe-test-tools = " \
        rt-tests \
"

RDEPENDS_packagegroup-oe-extra-dev-libraries = " \
"
RDEPENDS_packagegroup-oe-virtualization = " \
"

RDEPENDS_packagegroup-core-tools-profile = " \
"
RDEPENDS_packagegroup-oe-database-utilities = " \
"
RDEPENDS_packagegroup-oe-netprotocol-utilities = " \
"
