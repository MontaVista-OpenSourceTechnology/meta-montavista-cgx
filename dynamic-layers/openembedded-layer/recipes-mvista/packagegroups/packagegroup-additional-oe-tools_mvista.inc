OPROFILE="oprofile"
OPROFILE_linux-gnuilp32 = ""
#Fix Me: This should work
OPROFILE_linux-gnun32 = ""
OPROFILE_riscv64 = ""
OPROFILE_riscv = ""

RDEPENDS_packagegroup-oe-console-utilities_append = " \
	libc-client \
	${OPROFILE} \
	pax-utils \
	lvm2 \
	libol \
	smartmontools \
	vim \
	cdrkit \
	postgresql \
	postgresql-client \
	postgresql-timezone \
	multipath-tools \
	poco \
"

RDEPENDS_packagegroup-oe-extra-dev-libraries_append = " \
	${PMDK} \
"

PMDK = ""
PMDK_i586 = ""
PMDK_x86-64 = "pmdk"

RDEPENDS_packagegroups-oe-networkmanagement_append = " \
	sg3-utils \
	sg3-utils-udev \
	openldap \
	tipcutils \
	tipcutils-demos \
"

RDEPENDS_packagegroup-oe-database-utilities_append = " \
	mariadb-setupdb \
	mariadb-client \
	mariadb-server \
	libmysqlclient \
"

RDEPENDS_packagegroup-oe-filesystemutilities_append = " \
    python3-cpuset \
"

RDEPENDS_packagegroup-oe-virtualization_append = " \
	lua \
"

RDEPENDS_packagegroup-oe-hotplugutilities_append = " \
	pcmciautils \
"

RDEPENDS_packagegroups-oe-logmanagement_append = " \
	${VIRTUAL-RUNTIME_syslog} \
"

RDEPENDS_packagegroups-oe-mailclient_append = " \
	mailx \
"

X86_PACKAGES_OE_CONSOLE_UTILS_append_x86-64 = " \
	efibootmgr \
"

RDEPENDS_packagegroup-oe-security_append = " \
	liblockfile \
	lockfile-progs \
"
RDEPENDS_packagegroup-oe-wirelessutilities_append = "\
	irda-utils \
"
