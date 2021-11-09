
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

RDEPENDS:packagegroup-additional-oe-tools = "\
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

RDEPENDS:packagegroup-oe-filesystemutilities = "\
	squashfs-tools \
	cramfs \
"

RDEPENDS:packagegroup-oe-hotplugutilities = "\
	usbutils \
"

RDEPENDS:packagegroup-oe-wirelessutilities = "\
	irda-utils \
"
PREFERRED_PROVIDER_libunwind_toolchain-gcc = "libunwind"
PREFERRED_PROVIDER_libunwind ??= "libunwind"
RRECOMMENDS:packagegroup-oe-console-utilities = "linux-firmware"
RDEPENDS:packagegroup-oe-console-utilities = " \
	console-tools \
	cups \
	dosfstools \
	dtc \ 
	libcgroup \
	libgcc \
	run-postinsts \
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

RDEPENDS:packagegroups-oe-networkmanagement = " \
	gnupg \
	libcap-ng \
	ethtool \
	net-tools \
	dhcpcd \
	kea \
"
RDEPENDS:packagegroups-oe-logmanagement = " \
	consolekit \
	pam-plugin-ck-connector \
"

RDEPENDS:packagegroup-core-ssh-openssh = " \
"

RDEPENDS:packagegroups-oe-ftpserver = " \
"
RDEPENDS:packagegroups-oe-ftpclient = " \
"

RDEPENDS:packagegroups-oe-mailclient = " \
"
RDEPENDS:packagegroups-oe-mailserver = " \
"

RDEPENDS:packagegroup-oe-graphics = " \
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
# No longer in oe
#	libxxf86misc 
#	libxxf86dga 

RDEPENDS:packagegroup-oe-webserver = " \
"

RDEPENDS:packagegroup-oe-console-utils += "${X86_PACKAGES_OE_CONSOLE_UTILS}"

X86_PACKAGES_OE_CONSOLE_UTILS = ""

X86_PACKAGES_OE_CONSOLE_UTILS:x86-64 = " \
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

RDEPENDS:packagegroup-oe-security = " \
	pinentry \
	wireshark \
	tshark \
"

KDUMP="kdump-elftool"
KDUMP_riscv = ""
KDUMP:riscv64 = ""

GDB_KDUMP_HELPERS ?= "gdb-kdump-helpers"
GDB_KDUMP_HELPERS_riscv = ""
GDB_KDUMP_HELPERS:riscv64 = ""

RDEPENDS:packagegroup-oe-debug = " \
	${GDB_KDUMP_HELPERS} \
	${PREFERRED_PROVIDER_libunwind} \
	${KDUMP} \
"

RDEPENDS:packagegroup-oe-test-tools = " \
        rt-tests \
"

RDEPENDS:packagegroup-oe-extra-dev-libraries = " \
"
RDEPENDS:packagegroup-oe-virtualization = " \
"

RDEPENDS:packagegroup-core-tools-profile = " \
"
RDEPENDS:packagegroup-oe-database-utilities = " \
"
RDEPENDS:packagegroup-oe-netprotocol-utilities = " \
"
