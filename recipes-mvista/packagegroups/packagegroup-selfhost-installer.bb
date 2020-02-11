# Copyright (C) 2014 Montavista Inc
#

SUMMARY = "Self hosted installer"
DESCRIPTION = "Features required for self hosted installer to work"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = " \
        packagegroup-selfhost-installer \
	packagegroup-selfhost-installer-defaultimage \
    "

RDEPENDS_packagegroup-selfhost-installer-defaultimage = "${PACKAGES_OF_SELFHOST_INSTALLER_DEFAULTIMAGE}"
RDEPENDS_packagegroup-selfhost-installer = "${PACKAGES_OF_SELFHOST_INSTALLER}"


X86_PACKAGES_OF_SELFHOST_INSTALLER = "\
                kernel \
                kernel-modules \
                python3-debugger \
                linux-firmware \
                ${VIRTUAL-RUNTIME_init_manager} \
                ${VIRTUAL-RUNTIME_initscripts} \
                base-files \
                base-passwd \
                busybox \
                mvinstaller \
                uipartition \
                nfs-utils-client \
                strace \
"

X86_PACKAGES_OF_SELFHOST_INSTALLER_DEFAULTIMAGE = " \
                mvmkramdisk \
                grub \
                grep \
                util-linux-blkid \
           "

PACKAGES_OF_SELFHOST_INSTALLER = ""
PACKAGES_OF_SELFHOST_INSTALLER_i686 = "${X86_PACKAGES_OF_SELFHOST_INSTALLER}"
PACKAGES_OF_SELFHOST_INSTALLER_x86-64 = "${X86_PACKAGES_OF_SELFHOST_INSTALLER}"
PACKAGES_OF_SELFHOST_INSTALLER_x86-generic-64 = "${X86_PACKAGES_OF_SELFHOST_INSTALLER}"

PACKAGES_OF_SELFHOST_INSTALLER_DEFAULTIMAGE = ""
PACKAGES_OF_SELFHOST_INSTALLER_DEFAULTIMAGE_i686 = "${X86_PACKAGES_OF_SELFHOST_INSTALLER_DEFAULTIMAGE}"
PACKAGES_OF_SELFHOST_INSTALLER_DEFAULTIMAGE_x86-64 = "${X86_PACKAGES_OF_SELFHOST_INSTALLER_DEFAULTIMAGE}"
PACKAGES_OF_SELFHOST_INSTALLER_DEFAULTIMAGE_x86-generic-64 = "${X86_PACKAGES_OF_SELFHOST_INSTALLER_DEFAULTIMAGE}"

#RDEPENDS_packagegroup-selfhost-installer-defaultimage= "\
#			mvmkramdisk \
#                         grub \
#                         grep \
#                         util-linux-blkid \
#			"
