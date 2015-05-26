FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"
PR .= ".3"

do_install_append () {
    sed -i 's:touch /var/log/lastlog: \
if [ "\${ROOT_DIR}" == "/" ] ; then \
	touch /var/log/lastlog \
fi:' ${D}${sysconfdir}/init.d/populate-volatile.sh
    sed -i \
    's:test ! -x /sbin/restorecon || /sbin/restorecon -R /var/volatile/: \
if [ "\${ROOT_DIR}" == "/" ] ; then \
	test ! -x /sbin/restorecon || /sbin/restorecon -R /var/volatile/ \
fi:' ${D}${sysconfdir}/init.d/populate-volatile.sh
}
