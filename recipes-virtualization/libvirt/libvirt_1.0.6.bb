# Copyright (c) 2012 MontaVista Software LLC.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

require libvirt.inc

inherit update-rc.d

PR = "${INC_PR}.12"

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
	  file://libvirt-fix-cgroup-mount-detection.patch \
     "

SRC_URI[md5sum] = "a4a09a981f902c4d6aa5138c753d64fd"
SRC_URI[sha256sum] = "a188eb2056d7936c4c9605f4d435b9097880ec359e10be6546f2c9fa665de67d"

LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
              file://COPYING.LESSER;md5=4fbd65380cdd255951079008b364516c"
