PR .= ".1"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://cryptdisk_support"


# FIXME: Switched from using hard coded pathing. Needt to verify if scripts continue to work.

do_install:append () {

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

	install -d -m 0755 ${D}${nonarch_base_libdir}
	install -d -m 0755 ${D}/${nonarch_base_libdir}/cryptsetup
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/cryptdisks.functions ${D}/${nonarch_base_libdir}/cryptsetup/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/init-functions ${D}/${nonarch_base_libdir}/cryptsetup/

	# Create the /lib/cryptsetup/"checks" directory and install the files

	install -d -m 0755 ${D}/${nonarch_base_libdir}/cryptsetup/checks
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/checks/blkid ${D}/${nonarch_base_libdir}/cryptsetup/checks/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/checks/ext2 ${D}/${nonarch_base_libdir}/cryptsetup/checks/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/checks/swap ${D}/${nonarch_base_libdir}/cryptsetup/checks/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/checks/un_blkid ${D}/${nonarch_base_libdir}/cryptsetup/checks/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/checks/xfs ${D}/${nonarch_base_libdir}/cryptsetup/checks/

	# Create the /lib/cryptsetup/"scripts" directory and install the files

	install -d -m 0755 ${D}/${nonarch_base_libdir}/cryptsetup/scripts
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_derived ${D}/${nonarch_base_libdir}/cryptsetup/scripts/
        install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_gnupg ${D}/${nonarch_base_libdir}/cryptsetup/scripts/
        install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_keyctl ${D}/${nonarch_base_libdir}/cryptsetup/scripts/
        install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_openct ${D}/${nonarch_base_libdir}/cryptsetup/scripts/
        install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_opensc ${D}/${nonarch_base_libdir}/cryptsetup/scripts/
	install -m 0744 ${WORKDIR}/cryptdisk_support/lib/cryptsetup/scripts/decrypt_ssl ${D}/${nonarch_base_libdir}/cryptsetup/scripts/

	# Create the /${sbindir} directory and install the files

	install -d -m 0755 ${D}/${sbindir}
	install -m 0755 ${WORKDIR}/cryptdisk_support/sbin/cryptdisks_start ${D}/${sbindir}/
	install -m 0755 ${WORKDIR}/cryptdisk_support/sbin/cryptdisks_stop ${D}/${sbindir}/

# Switch to using the variable since it needs to obey usrmerge
#	mv ${D}/usr/${sbindir}/cryptsetup ${D}/${sbindir}/
#	mv ${D}/usr/${sbindir}/veritysetup ${D}/${sbindir}/
#	rm -rf ${D}/usr/${sbindir}

	# copy systemd cryptsetup services and udev rules
	install -d -m 0755 ${D}/${nonarch_base_libdir}/udev
	install -d -m 0755 ${D}/${nonarch_base_libdir}/udev/rules.d

	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
	      install -d -m 0755 ${D}/${nonarch_base_libdir}/systemd
	      install -d -m 0755 ${D}/${nonarch_base_libdir}/systemd/system

	      install -m 0744 ${WORKDIR}/cryptdisk_support/lib/udev/rules.d/systemd-cryptdisks.rules ${D}/${nonarch_base_libdir}/udev/rules.d/98-cryptdisks.rules
	      install -m 0644 ${WORKDIR}/cryptdisk_support/lib/systemd/system/cryptsetup@.service ${D}/${nonarch_base_libdir}/systemd/system/
	      install -m 0644 ${WORKDIR}/cryptdisk_support/lib/systemd/system/cryptsetup-umount@.service ${D}/${nonarch_base_libdir}/systemd/system/
	else
		install -m 0744 ${WORKDIR}/cryptdisk_support/lib/udev/rules.d/cryptdisks.rules ${D}/${nonarch_base_libdir}/udev/rules.d/98-cryptdisks.rules
	fi
}

FILES:${PN} += "${sbindir}/*  /etc/* /${nonarch_base_libdir}/*"


