# mvinstaller

LICENSE="CLOSED"

DESCRIPTION="A basic installer for installing MV Linux"
HOMEPAGE="http://www.mvista.com"

# No need to build this in a normal build.
PR = "r2"
DEPENDS += "mtools"

RDEPENDS_${PN} = "grub efibootmgr python python-readline \
                util-linux-mount \
                util-linux-umount\
                util-linux \
                mdadm \
                lvm2 \
                e2fsprogs e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-tune2fs \
                dosfstools \
                "
SRC_URI = "file://mktmpwrite \
	  file://ifuploop \
	  file://installer.py \
"
S="${WORKDIR}"

INSTALLER_TARBALL ?= ""
USER_INSTALLER ?= ""

do_install() {
	install -d ${D}/etc/init.d
	install -d ${D}/etc/rcS.d
	install -d ${D}/usr/lib
	touch ${D}/etc/ld.so.conf
	install -m 0755 mktmpwrite ${D}/etc/init.d
	ln -sf ../init.d/mktmpwrite ${D}/etc/rcS.d/S01mktmpwrite
	install -m 0755 ifuploop ${D}/etc/init.d
	ln -sf ../init.d/ifuploop ${D}/etc/rcS.d/S40ifuploop
	install -m 0755 installer.py ${D}/installer.py
	mkdir ${D}/t

	if [ "x${USER_INSTALLER}" != "x" ]; then
		install -m 755 "${USER_INSTALLER}" ${D}/user_installer.py
	fi
}

# Always run the installer step, in case USER_INSTALLER changed.
do_install[nostamp] = "1"

PACKAGES = "${PN}"
PROVIDES = "${PACKAGES}"
FILES_${PN} = "/installer.py /t /etc/init.d/mktmpwrite \
	    /etc/rcS.d/S01mktmpwrite \
	    /etc/init.d/ifuploop /etc/rcS.d/S40ifuploop \
	    /to_install.tar.gz"
FILES_${PN} += "/user_installer.py*"
