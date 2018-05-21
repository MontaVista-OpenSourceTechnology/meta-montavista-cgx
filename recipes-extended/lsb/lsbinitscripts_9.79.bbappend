# Copyright (c) 2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#
PR .= ".3"

FILESEXTRAPATHS_prepend := "${THISDIR}/lsbinitscripts:"

SRC_URI += "file://avoid_invalid_msg_print_on_stderr.patch"

do_install_append () {
    # Use systemctl command to run services only when DISTRO_FEATURES
    # has systemd. Don't use it based on mounting of /sys/fs/cgroup/systemd.
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'false', 'true', d)}; then
        [ -e "${D}${sysconfdir}/init.d/functions" ] && sed -i \
        "s|_use_systemctl=1|_use_systemctl=0|g" ${D}${sysconfdir}/init.d/functions
    fi
    mv ${D}${sysconfdir}/init.d/functions ${D}${sysconfdir}/init.d/functions.${PN}
}

pkg_postinst_${PN} () {
#!/bin/sh
    update-alternatives --install ${sysconfdir}/init.d/functions functions functions.${PN}  100
}

BBCLASSEXTEND = "native"
