# Copyright (c) 2012 MontaVista Software LLC.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

require libvirt.inc

inherit update-rc.d

PR = "${INC_PR}.4"

INITSCRIPT_NAME = "libvirtd"
INITSCRIPT_PARAMS = "defaults 90 10"

DEPENDS += "dbus ${@get_dependency_libvirt(bb, d)}"

RDEPENDS_${PN} += "dnsmasq"

EXTRA_OECONF += " --with-sasl=no --with-dnsmasq=no --with-yajl=no ${@get_dtrace_option_libvirt(bb, d)}"

SRC_URI += " file://remove-RHism.diff.patch \ 
             file://increase-unix-socket-timeout.patch \
             file://add-vendor-and-device-to-pciDeviceFileIterate.patch \
             file://dont_clobber_existing_bridges.patch \
          file://add_support_for_mips_cpu_options_parsing.patch \
          file://make_dnsmasq_conditional.patch \
          file://libvirt-fix-libnl-detect.patch \
          file://libvirt-dont-require-selinux-mounts.patch \
	  file://libvirt-fix-mount-detection.patch \
	  file://LXC-Create-dev-tty-within-a-container.patch \
	  file://add_support_for_ARMv7_BE_for_libvirt.patch \
	  file://add_support_for_AARCH64_for_libvirt.patch\
     "

SRC_URI[md5sum] = "f980a84719033e9efca01048da505dfb"
SRC_URI[sha256sum] = "ce9e765697ecb595469489665043ce221d9b70babc16fec77ee938fe37676928"

LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
              file://COPYING.LESSER;md5=4fbd65380cdd255951079008b364516c"
