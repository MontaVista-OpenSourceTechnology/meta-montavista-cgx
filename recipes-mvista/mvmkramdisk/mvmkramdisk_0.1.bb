# mvmkramdisk

LICENSE="GPL-2.0"
LIC_FILES_CHKSUM = "file://init_template;beginline=1;endline=19;md5=b38562175ffb2271d15ed8496d7724a6"
DESCRIPTION="Create boot ramdisks for MV Linux"
HOMEPAGE="http://www.mvista.com"

# A few notes here. We need all the tools that go onto the ramdisk here.
# mount and cpio from busybox are missing some required capabilities
# for other tools.  kernel-dev gets the System.map required for depmod
# to work.  (depmod is in util-linux).  ldd requires bash, unfortunately,
# and does not list this in its RDEPENDS.
RDEPENDS_${PN} = "busybox \
		  util-linux \
		  util-linux-mount \
		  util-linux-umount \
		  linux-firmware \
		  kernel-dev \
		  mdadm \
		  ldd \
		  cpio \
		  bash \
		 "
RDEPENDS_${PN}_append_i386 = " grub"
RDEPENDS_${PN}_append_x86_64 = " grub"

# Skip dev-packages rdependency test.
INSANE_SKIP_${PN} = "dev-deps"

PR = "r11"

SRC_URI = "file://mvmkramdisk \
	  file://mv-re-grub \
	  file://init_template \
	  file://required_binaries \
	  file://required_modules \
	  file://required_files \
	  file://hotplug \
          file://local_declare_pos_chg.patch \ 
"
S="${WORKDIR}"

MVMKRAMDISK_REQUIRED_BINARIES ?= "required_binaries"
MVMKRAMDISK_REQUIRED_MODULES ?= "required_modules"
MVMKRAMDISK_REQUIRED_FILES ?= "required_files"

do_install() {
	install -d ${D}/usr/share/mvmkramdisk
	install -d ${D}/usr/sbin
	install -m 0644 init_template ${D}/usr/share/mvmkramdisk
	install -m 0644 "${MVMKRAMDISK_REQUIRED_BINARIES}" \
		${D}/usr/share/mvmkramdisk/required_binaries
	install -m 0644 "${MVMKRAMDISK_REQUIRED_MODULES}" \
		${D}/usr/share/mvmkramdisk/required_modules
	install -m 0644 "${MVMKRAMDISK_REQUIRED_FILES}" \
		${D}/usr/share/mvmkramdisk/required_files
	install -m 0755 hotplug ${D}/usr/share/mvmkramdisk/hotplug
	install -m 0755 mvmkramdisk ${D}/usr/sbin
	install -m 0755 mv-re-grub ${D}/usr/sbin
        sed -i 's,/%LIB%/udev/firmware,,' ${D}${datadir}/mvmkramdisk/required_binaries #TODO: Need to know purpose of firmware
        install -m  0755 mvmkramdisk ${D}${sbindir}/mvmkramdisk
}

PACKAGES = "${PN}"
PROVIDES = "${PACKAGES}"
RPROVIDES_${PN} = "${PACKAGES}"
FILES_${PN} = "/usr/sbin/mvmkramdisk /usr/sbin/mv-re-grub \
	      /usr/share/mvmkramdisk/init_template \
	      /usr/share/mvmkramdisk/required_binaries \
	      /usr/share/mvmkramdisk/required_modules \
	      /usr/share/mvmkramdisk/required_files \
	      /usr/share/mvmkramdisk/hotplug \
	      "
PACKAGE_ARCH = "${MACHINE_ARCH}"
