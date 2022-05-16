OPROFILE="oprofile"
OPROFILE_linux-gnuilp32 = ""
#Fix Me: This should work
OPROFILE:linux-gnun32 = ""
OPROFILE:riscv64 = ""
OPROFILE_riscv = ""

RDEPENDS:packagegroup-oe-console-utilities:append = " \
	libc-client \
	${OPROFILE} \
	pax-utils \
	lvm2 \
	libol \
	smartmontools \
	vim \
	icedax \
	wodim \
	genisoimage \
	dirsplit \
	postgresql \
	postgresql-client \
	postgresql-timezone \
	multipath-tools \
	poco \
"

RDEPENDS:packagegroup-oe-extra-dev-libraries:append = " \
	${PMDK} \
"

PMDK = ""
PMDK_i586 = ""
PMDK:x86-64 = "pmdk"

RDEPENDS:packagegroups-oe-networkmanagement:append = " \
	sg3-utils \
	sg3-utils-udev \
	openldap \
	tipcutils \
	tipcutils-demos \
"

RDEPENDS:packagegroup-oe-database-utilities:append = " \
	mariadb-setupdb \
	mariadb-client \
	mariadb-server \
	libmysqlclient \
"

RDEPENDS:packagegroup-oe-filesystemutilities:append = " \
    python3-cpuset \
"

RDEPENDS:packagegroup-oe-virtualization:append = " \
	lua \
"

RDEPENDS:packagegroup-oe-hotplugutilities:append = " \
	pcmciautils \
"

RDEPENDS:packagegroups-oe-logmanagement:append = " \
	${VIRTUAL-RUNTIME_base-utils-syslog} \
"

RDEPENDS:packagegroups-oe-mailclient:append = " \
"

# FIXME: mailx was removed.
X86_PACKAGES_OE_CONSOLE_UTILS:append:x86-64 = " \
	efibootmgr \
"

RDEPENDS:packagegroup-oe-security:append = " \
	liblockfile \
	lockfile-progs \
"
