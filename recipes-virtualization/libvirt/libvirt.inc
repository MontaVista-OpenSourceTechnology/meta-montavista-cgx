# Copyright (c) 2010, 2011, 2012, 2013 MontaVista Software LLC.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

DESCRIPTION = "A portable virtualization API"
HOMEPAGE = "http://libvirt.org"
SECTION = "console/utils"
PRIORITY = "optional"
LICENSE = "LGPLv2+"

NUMADEP="numactl"
NUMADEP_arm = ""
NUMADEP_armeb = ""
NUMADEP_aarch64 = ""
NUMADEP_aarch64be = ""

NUMA = "--with-numactl"
NUMA_arm = "--with-numactl=no"
NUMA_armeb = "--with-numactl=no"
NUMA_aarch64 = "--with-numactl=no"
NUMA_aarch64be = "--with-numactl=no"

DEPENDS = "gnutls libnl libpcap libcap-ng \
           libxml2 gnutls ncurses python virtual/kernel \
           libpcap ${NUMADEP} lvm2 curl avahi libpciaccess systemtap-native \
	   parted"
RDEPENDS_${PN} += "bridge-utils gawk iptables iproute2 python lvm2 ebtables"
INC_PR = "r34"

SRC_URI = "http://libvirt.org/sources/libvirt-${PV}.tar.gz \
       file://libvirtd.init \
       file://libvirtd.default \
       file://libvirtd.logrotate \
       file://45_libvirt \
      "

inherit autotools distutils gettext

PYTHON_INC_DIR = "-I${STAGING_INCDIR}/${PYTHON_DIR}"
CFLAGS =+ "${PYTHON_INC_DIR}"
export am_cv_python_pyexecdir="${libdir}/${PYTHON_DIR}"
export ac_cv_path_IP_PATH="/bin/ip"
export IPTABLES_PATH="${sbindir_native}/iptables"
export IP6TABLES_PATH="${sbindir_native}/ip6tables"
export DNSMASQ="/usr/sbin/dnsmasq"
EXTRA_OECONF += "--with-python --with-libpcap --with-libnl \
           --with-network --with-libvirtd --with-openvz \
           --with-test --with-remote --with-macvtap \
           --with-libpcap ${NUMA} \
           --with-storage-mpath=no \
           --enable-test-oom"

DEPENDS += "${@base_contains("DISTRO_FEATURES", "selinux", "libselinux", "", d)}"
EXTRA_OECONF += "${@base_contains("DISTRO_FEATURES", "selinux", "--with-selinux=yes --with-secdriver-selinux=yes", "", d)}"

DEPENDS += "${@base_contains("DISTRO_FEATURES", "audit", "audit", "", d)}"
EXTRA_OECONF += "${@base_contains("DISTRO_FEATURES", "audit", "--with-audit", "", d)}"

DEPENDS += "${@base_contains("DISTRO_FEATURES", "containers", "lxc", "", d)}"
EXTRA_OECONF += "${@base_contains("DISTRO_FEATURES", "containers", "--with-lxc", "", d)}"

DEPENDS += "${@base_contains("DISTRO_FEATURES", "kvm", "qemu-kvm", "", d)}"
EXTRA_OECONF += "${@base_contains("DISTRO_FEATURES", "kvm", "--with-qemu", "", d)}"

DEPENDS += "${@base_contains("DISTRO_FEATURES", "graphics", "hal udev libpciaccess policykit", "", d)}"
EXTRA_OECONF += "${@base_contains("DISTRO_FEATURES", "graphics", "--with-hal --with-udev --with-polkit", "", d)}"


do_compile() {
     oe_runmake
}

do_install() {
     oe_runmake 'DESTDIR=${D}' install
     install -m 0755 -D -d ${D}${sysconfdir}/default
     install -m 0644 ${WORKDIR}/libvirtd.default ${D}${sysconfdir}/default/libvirtd
     install -m 0755 -D -d ${D}${sysconfdir}/init.d
     install -m 0755 ${WORKDIR}/libvirtd.init ${D}${sysconfdir}/init.d/libvirtd
     install -m 0755 -D -d ${D}${sysconfdir}/logrotate.d
     install -m 0644 ${WORKDIR}/libvirtd.logrotate ${D}${sysconfdir}/logrotate.d/libvirtd
     install -d ${D}/${sysconfdir}/default/volatiles
     install -m 0644 ${WORKDIR}/45_libvirt ${D}/${sysconfdir}/default/volatiles

     # Remove extraneous cruft that gets installed.
     rm -rf ${D}/var/cache ${D}/var/run ${D}/var/log ${D}/var/volatile
}

# Remove multiple entry of ${PN}-staticdev
PACKAGES =+ "${PN}-python-dbg ${PN}-python ${PN}-lxc ${PN}-qemu \
          ${PN}-qemu-staticdev ${PN}-qemu-dev"

FILES_${PN}-staticdev = "${libdir}/*.a ${libdir}/libvirt/connection-driver/*.a"
FILES_${PN}-dbg += "${bindir}/.debug ${sbindir}/.debug ${libdir}/.debug \
          ${libexecdir}/.debug ${libdir}/libvirt/connection-driver/.debug \
	  ${libdir}/libvirt/lock-driver/.debug"
FILES_${PN}-python = "${libdir}/${PYTHON_DIR}"
FILES_${PN}-python-dbg = "${libdir}/${PYTHON_DIR}/.debug"
FILES_${PN}-lxc =  "${sysconfdir}/logrotate.d/libvirtd.lxc ${sysconfdir}/libvirt/lxc.conf \
              ${datadir}/augeas/lenses/libvirtd_lxc.aug \
              ${datadir}/augeas/lenses/tests/test_libvirtd_lxc.aug \
              ${libexecdir}/libvirt_lxc  \
              ${localstatedir}/lib/libvirt/lxc"
FILES_${PN}-qemu = "${sysconfdir}/logrotate.d/libvirtd.qemu \
              ${sysconfdir}/libvirt/nwfilter/qemu-announce-self-rarp.xml \
              ${sysconfdir}/libvirt/nwfilter/qemu-announce-self.xml \
              ${sysconfdir}/libvirt/qemu \
              ${sysconfdir}/libvirt/qemu/networks \
              ${sysconfdir}/libvirt/qemu/networks/default.xml \
              ${sysconfdir}/libvirt/qemu/networks/autostart \
              ${sysconfdir}/libvirt/qemu/networks/autostart/default.xml \
              ${sysconfdir}/libvirt/qemu.conf \
              ${datadir}/augeas/lenses/libvirtd_qemu.aug \
              ${datadir}/augeas/lenses/tests/test_libvirtd_qemu.aug \
              ${libdir}/libvirt-qemu.so.${PV} \
              ${libdir}/libvirt-qemu.so.* \
              ${localstatedir}/lib/libvirt/qemu"
FILES_${PN}-qemu-dev = "${sysconfdir}/logrotate.d/libvirtd.qemu \
              ${includedir}/libvirt/libvirt-qemu.h \
              ${libdir}/libvirt-qemu.la \
              ${libdir}/libvirt-qemu.so"
FILES_${PN}-qemu-staticdev = "${libdir}/libvirt-qemu.a"
FILES_${PN} +=     "${sysconfdir} ${bindir} ${sbindir} ${libexecdir} \
              ${datadir} ${localstatedir}/lib/libvirt \
              ${prefix}/lib/sysctl.d"

pkg_postinst_libvirt () {
     # can't do this offline
     if [ "x$D" != "x" ]; then
          exit 1
     fi

     ${sysconfdir}/init.d/populate-volatile.sh update
}

def get_dependency_libvirt(bb, d):
        import re
        deps = bb.data.getVar('TARGET_PREFIX', d, True)
        if re.search("(x86_64|powerpc|i.86|arm).*",deps):
                return "systemtap"
        else:
                return ""

def get_dtrace_option_libvirt(bb, d):
        import re
        deps = bb.data.getVar('TARGET_PREFIX', d, True)
        if re.search("(x86_64|powerpc|i.86|arm).*",deps):
                return "--with-dtrace ac_cv_path_DTRACE=${STAGING_BINDIR_NATIVE}/dtrace"
        else:
                return "--with-dtrace=no"
