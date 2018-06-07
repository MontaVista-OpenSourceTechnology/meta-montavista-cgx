PR .= ".1"


inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} += "${@bb.utils.contains('DISTRO_FEATURES','systemd','${systemd_unitdir}/libsystemd-shared.la','',d)}"
#FIXME: this shouldn't be needed
pkg_postinst_udev-hwdb () {
        if test -n "$D"; then
                chown root:root $D${sysconfdir}/udev/hwdb.bin
                false
        else
                udevadm hwdb --update
        fi
}

