PR .= ".3"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
            file://0001-networkd-Add-static-address-as-IFA_F_PERMANENT.patch  \
            file://0002-Fixed-EINVAL-in-systemd-udevd-processing-of-speed-du.patch \
            file://0001-Revert-core-don-t-load-dropin-data-multiple-times-fo.patch \
            file://CVE-2018-15688.patch\
"

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} += "${@bb.utils.contains('DISTRO_FEATURES','systemd','${systemd_unitdir}/libsystemd-shared.la','',d)}"
