PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://cryptdisk_support"

do_install_append () {

	# Create the /etc , supporting directories and install the files

	install -d -m 0755 ${D}/etc
	install -d -m 0755 ${D}/etc/bash_completion.d ${D}/etc/default ${D}/etc/init.d ${D}/etc/rc0.d ${D}/etc/rc6.d

	install -m 0755 ${WORKDIR}/cryptdisk_support/etc/crypttab ${D}/etc/
	install -m 0755 ${WORKDIR}/cryptdisk_support/etc/bash_completion.d/cryptdisks ${D}/etc/bash_completion.d/
	install -m 0755 ${WORKDIR}/cryptdisk_support/etc/default/cryptdisks ${D}/etc/default/	
	install -m 0755 ${WORKDIR}/cryptdisk_support/etc/init.d/cryptdisks ${D}/etc/init.d/
	install -m 0755 ${WORKDIR}/cryptdisk_support/etc/init.d/cryptdisks-early ${D}/etc/init.d/
	install -m 0755 ${WORKDIR}/cryptdisk_support/etc/rc0.d/S59cryptdisks-early ${D}/etc/rc0.d/
	install -m 0755 ${WORKDIR}/cryptdisk_support/etc/rc6.d/S59cryptdisks-early ${D}/etc/rc6.d/

	install -d -m 0755 ${D}/lib
	install -d -m 0755 ${D}/lib/cryptsetup
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/cryptdisks.functions ${D}/lib/cryptsetup/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/init-functions ${D}/lib/cryptsetup/

	# Create the /lib/cryptsetup/"checks" directory and install the files

	install -d -m 0755 ${D}/lib/cryptsetup/checks
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/checks/blkid ${D}/lib/cryptsetup/checks/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/checks/ext2 ${D}/lib/cryptsetup/checks/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/checks/swap ${D}/lib/cryptsetup/checks/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/checks/un_blkid ${D}/lib/cryptsetup/checks/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/checks/xfs ${D}/lib/cryptsetup/checks/

	# Create the /lib/cryptsetup/"scripts" directory and install the files

	install -d -m 0755 ${D}/lib/cryptsetup/scripts
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_derived ${D}/lib/cryptsetup/scripts/
        install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_gnupg ${D}/lib/cryptsetup/scripts/
        install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_keyctl ${D}/lib/cryptsetup/scripts/
        install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_openct ${D}/lib/cryptsetup/scripts/
        install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_opensc ${D}/lib/cryptsetup/scripts/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_ssl ${D}/lib/cryptsetup/scripts/

	# Create the /sbin directory and install the files

	install -d -m 0755 ${D}/sbin
	install -m 0755 ${WORKDIR}/cryptdisk_support/sbin/cryptdisks_start ${D}/sbin/
	install -m 0755 ${WORKDIR}/cryptdisk_support/sbin/cryptdisks_stop ${D}/sbin/

	mv ${D}/usr/sbin/cryptsetup ${D}/sbin/
	mv ${D}/usr/sbin/veritysetup ${D}/sbin/
	rm -rf ${D}/usr/sbin

	# copy systemd cryptsetup services and udev rules
	install -d -m 0755 ${D}/lib/udev
	install -d -m 0755 ${D}/lib/udev/rules.d

	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
	      install -d -m 0755 ${D}/lib/systemd
	      install -d -m 0755 ${D}/lib/systemd/system

	      install -m 0744 ${WORKDIR}/cryptdisk_support/lib/udev/rules.d/systemd-cryptdisks.rules ${D}/lib/udev/rules.d/98-cryptdisks.rules
	      install -m 0644 ${WORKDIR}/cryptdisk_support/lib/systemd/system/cryptsetup@.service ${D}/lib/systemd/system/
	      install -m 0644 ${WORKDIR}/cryptdisk_support/lib/systemd/system/cryptsetup-umount@.service ${D}/lib/systemd/system/
	else
		install -m 0744 ${WORKDIR}/cryptdisk_support/lib/udev/rules.d/cryptdisks.rules ${D}/lib/udev/rules.d/98-cryptdisks.rules
	fi
}

FILES_${PN} += "${sbindir}/* /etc/* /lib/*"


