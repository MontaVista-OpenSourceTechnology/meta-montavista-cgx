PR .= ".2"

PACKAGES += "${PN}-busyboxless"

RDEPENDS:${PN}-busyboxless = "\
    base-files \
    base-passwd \
    ${@bb.utils.contains("MACHINE_FEATURES", "keyboard", "${VIRTUAL-RUNTIME_keymaps}", "", d)} \
    modutils-initscripts \
    netbase \
    init-ifupdown \
    ${VIRTUAL-RUNTIME_init_manager} \
    ${VIRTUAL-RUNTIME_initscripts} \
    ${VIRTUAL-RUNTIME_dev_manager} \
    ${VIRTUAL-RUNTIME_update-alternatives} \
    ${MACHINE_ESSENTIAL_EXTRA_RDEPENDS} \
    util-linux-mount \
    util-linux-agetty \
    util-linux-umount \
    dpkg-start-stop \
    sed \
    gawk \
    ${VIRTUAL-RUNTIME_base-utils-syslog} \
    diffutils \
    coreutils \
    grep \
    openssh-sshd \
    net-tools \
"

RRECOMMENDS:${PN}-busyboxless = "\
    ${MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS}"

RDEPENDS:${PN} += "${@bb.utils.contains('DISTRO_FEATURES','systemd','','cgroup-lite',d)}"
