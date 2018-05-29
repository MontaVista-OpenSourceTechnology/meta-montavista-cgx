PR .= ".1"


inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} += "${@bb.utils.contains('DISTRO_FEATURES','systemd','${systemd_unitdir}/libsystemd-shared.la','',d)}"
