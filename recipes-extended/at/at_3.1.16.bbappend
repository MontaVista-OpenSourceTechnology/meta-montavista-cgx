PR .= ".2"

DEPENDS += "bison-native base-passwd"
# Change username and group to daemon, to allow normal users to schedule
# at jobs.
EXTRA_OECONF += "--with-daemon_username=daemon \
		 --with-daemon_groupname=daemon \
                "

# Below steps are needed inorder to schedule jobs using at
# by normal user
pkg_postinst_${PN} () {
    if [ x"$D" != "x" ]; then
        exit 1
    fi
    
    chown daemon:daemon /var/spool/at/jobs
    chown daemon:daemon /var/spool/at/spool
    chown daemon:daemon /var/spool/at/jobs/.SEQ
    chmod 1770 /var/spool/at/jobs
    chmod 1770 /var/spool/at/spool
    chown daemon:daemon ${bindir}/at
    chmod ug+s ${bindir}/at
    chmod 755 ${sbindir}/atd
    chmod 644 /etc/at.deny
}

