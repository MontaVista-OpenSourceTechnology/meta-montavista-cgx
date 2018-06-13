PR .= ".2"

DEPENDS += "bison-native base-passwd"
# Change username and group to daemon, to allow normal users to schedule
# at jobs.
EXTRA_OECONF += "--with-daemon_username=atd \
		 --with-daemon_groupname=atd \
                "
inherit useradd
USERADD_PACKAGES = "${PN}"
USERADD_PARAM_${PN} = "--system --home ${localstatedir}/spool/at --no-create-home \
                       --user-group atd"

do_install_append () {
    chown atd:atd ${D}${localstatedir}/spool/at/jobs
    chown atd:atd ${D}${localstatedir}/spool/at/spool
    chown atd:atd ${D}${localstatedir}/spool/at/jobs/.SEQ
    chmod 1770 ${D}${localstatedir}/spool/at/jobs
    chmod 1770 ${D}${localstatedir}/spool/at/spool
    chown atd:atd ${D}${bindir}/at
    chmod ug+s ${D}${bindir}/at
    chmod 755 ${D}${sbindir}/atd
    chmod 644 ${D}${sysconfdir}/at.deny
}
