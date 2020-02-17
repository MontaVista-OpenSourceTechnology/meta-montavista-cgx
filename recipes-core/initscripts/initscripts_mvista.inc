FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
PR .= ".4"

# FIXME: /etc/init.d/functions file from lsbinitscripts and
# mlib-initscripts-functions conflicts at cgx-complete-image:do_populate_sdk

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
PACKAGE_PREPROCESS_FUNCS += " move_functions "

move_functions () {
    mv ${PKGD}${sysconfdir}/init.d/functions ${PKGD}${sysconfdir}/init.d/functions.${PN}
}

def get_priority(d):
          pnMult = d.getVar("PN", True)
          bpnMult = d.getVar("BPN", True)
          if (pnMult == bpnMult):
             return "10"
          else:
             return "5"

ALTERNATIVE_PRIORITY="${@get_priority(d)}"

pkg_postinst_${PN}-functions () {
#!/bin/sh
    update-alternatives --install ${sysconfdir}/init.d/functions functions functions.${PN}  ${ALTERNATIVE_PRIORITY}
}
