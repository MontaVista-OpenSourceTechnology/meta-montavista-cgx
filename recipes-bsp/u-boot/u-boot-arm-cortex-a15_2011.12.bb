require recipes-bsp/u-boot/u-boot.inc

PR = "r0"
PN="u-boot"
LICENSE = "GPLv2+"

LIC_FILES_CHKSUM = "file://COPYING;md5=1707d6db1d42237583f50183a5651ecb \
                    file://README;beginline=1;endline=4873;md5=3db29a794efdc7d8421d73f29854bcba"

SRC_URI = "ftp://ftp.denx.de/pub/u-boot/u-boot-2011.12.tar.bz2 \
    file://3316-ARM-vexpress-move-files-in-preparation-for-adding-a-.patch \
    file://3317-ARM-vexpress-create-A9-specific-board-config.patch \
    file://3318-ARM-vexpress-create-A5-specific-board-config.patch \
    file://3319-ARM-vexpress-Change-maintainer-for-ARM-Versatile-Exp.patch \
    file://3320-ARM-vexpress-Extend-default-boot-sequence-to-load-sc.patch \
    file://3340-vexpress-hacks-Force-load-address-of-kernels-to-RAM-.patch \
    file://3341-vexpress-hacks-Make-default-boot-command-boot-from-M.patch \
    file://3342-vexpress-hacks-Remove-some-unnecessary-kernel-args.patch \
    file://3343-vexpress-hacks-Add-U-Boot-for-A15.patch \
    file://3344-vexpress-hacks-Increase-MMC-clock-rate-on-A15.patch \
    file://3345-vexpress-hacks-Update-default-bootargs-to-set-root-d.patch \
    file://3346-vexpress-hacks-Add-correct-terminator-to-default-mmc.patch \
    file://3347-vexpress-hacks-Remove-console-tty0-from-default-mmc_.patch \
    file://3348-vexpress-hacks-Add-androidboot.console-ttyAMA0-to-de.patch \
    "

S = "${WORKDIR}/u-boot-2011.12"

COMPATIBLE_MACHINE = "arm-cortex-a15"
UBOOT_MACHINE = "vexpress_ca15x2_config"
PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI[md5sum] = "7f29b9f6da44d6e46e988e7561fd1d5f"
SRC_URI[sha256sum] = "41820d65eb848411f71b9222957b3532607be0a754da916067876194148b907c"

