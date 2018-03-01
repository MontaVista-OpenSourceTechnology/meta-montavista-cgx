FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"
PR .= ".4"

# FIXME: /etc/init.d/functions file from lsbinitscripts and
# mlib-initscripts-functions conflicts at cgx-complete-image:do_populate_sdk

do_install_extra () {
    mv ${D}${sysconfdir}/init.d/functions ${D}${sysconfdir}/init.d/functions.${PN}
}

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
pkg_postinst_${PN} () {
#!/bin/sh
    update-alternatives --install ${sysconfdir}/init.d/functions functions functions.${PN}  10
}


addtask install_extra after do_install before do_package
