# Copyright (c) 2012 MontaVista Software LLC.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

require libvirt.inc

inherit update-rc.d

PR = "${INC_PR}.10"

INITSCRIPT_NAME = "libvirtd"
INITSCRIPT_PARAMS = "defaults 90 10"

DEPENDS += "dbus ${@get_dependency_libvirt(bb, d)}"

EXTRA_OECONF += " --with-sasl=no --with-dnsmasq=no --with-yajl=no ${@get_dtrace_option_libvirt(bb, d)}"

SRC_URI += " file://remove-RHism.diff.patch \ 
             file://better-default-arch.patch \
             file://increase-unix-socket-timeout.patch \
             file://add-vendor-and-device-to-pciDeviceFileIterate.patch \
             file://dont_clobber_existing_bridges.patch \
          file://add_support_for_mips_cpu_options_parsing.patch \
          file://make_dnsmasq_conditional.patch \
          file://libvirt-fix-libnl-detect.patch \
          file://libvirt-fix-cgroup-scan.patch \
          file://libvirt-dont-require-selinux-mounts.patch \
	  file://include_linux_in6_h.patch \
     "

SRC_URI[md5sum] = "7c8b006de7338e30866bb56738803b21"
SRC_URI[sha256sum] = "14c8a30ebfb939c82cab5f759a95d09646b43b4210e45490e92459ae65123076"

LIC_FILES_CHKSUM = "file://COPYING;md5=fb919cc88dbe06ec0b0bd50e001ccf1f \
              file://COPYING.LIB;md5=fb919cc88dbe06ec0b0bd50e001ccf1f"
