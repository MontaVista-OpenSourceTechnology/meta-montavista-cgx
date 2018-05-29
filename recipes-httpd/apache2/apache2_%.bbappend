PR .= ".1"

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "${sbindir}/envvars \
                               ${sbindir}/envvars-std \
                               ${sysconfdir}/apache2/httpd.conf \
                               ${datadir}/apache2/build/config.nice \
                               ${datadir}/apache2/build/config_vars.mk \
                               ${sysconfdir}/apache2/extra/httpd-ssl.conf "
#Fix me alternatives don't work with init.d any more
#                               ${sysconfdir}/init.d/apache2 
MULTILIB_HEADERS = "apache2/ap_config_layout.h"
SSTATE_SCAN_FILES_remove = "config_vars.mk"
SSTATE_SCAN_FILES += "config_vars.mk.${PN}"

do_install_append () {
    mv ${D}${sysconfdir}/init.d/apache2 ${D}${sysconfdir}/init.d/apache2.${PN}
}
FILE_${PN} += "${sysconfdir}/init.d/apache2.${PN}"
apache_sysroot_preprocess () {
    install -d ${SYSROOT_DESTDIR}${bindir_crossscripts}/
    install -m 755 ${D}${bindir}/apxs ${SYSROOT_DESTDIR}${bindir_crossscripts}/
    install -d ${SYSROOT_DESTDIR}${sbindir}/
    install -m 755 ${D}${sbindir}/apachectl ${SYSROOT_DESTDIR}${sbindir}/
    sed -i 's!my $installbuilddir = .*!my $installbuilddir = "${STAGING_DIR_HOST}/${datadir}/${BPN}/build";!' ${SYSROOT_DESTDIR}${bindir_crossscripts}/apxs
    sed -i 's!my $libtool = .*!my $libtool = "${STAGING_BINDIR_CROSS}/${HOST_SYS}-libtool";!' ${SYSROOT_DESTDIR}${bindir_crossscripts}/apxs
    sed -i 's!config_vars\.mk!config_vars\.mk\.${PN}!g' ${SYSROOT_DESTDIR}${bindir_crossscripts}/apxs

    sed -i 's!^APR_CONFIG = .*!APR_CONFIG = ${STAGING_BINDIR_CROSS}/apr-1-config!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk.${PN}
    sed -i 's!^APU_CONFIG = .*!APU_CONFIG = ${STAGING_BINDIR_CROSS}/apu-1-config!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk.${PN}
    sed -i 's!^includedir = .*!includedir = ${STAGING_INCDIR}/apache2!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk.${PN}
    sed -i 's!^CFLAGS = -I[^ ]*!CFLAGS = -I${STAGING_INCDIR}/openssl!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk.${PN}
    sed -i 's!^EXTRA_LDFLAGS = .*!EXTRA_LDFLAGS = -L${STAGING_LIBDIR}!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk.${PN}
    sed -i 's!^EXTRA_INCLUDES = .*!EXTRA_INCLUDES = -I$(includedir) -I. -I${STAGING_INCDIR}!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk.${PN}
    sed -i 's!--sysroot=[^ ]*!--sysroot=${STAGING_DIR_HOST}!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk.${PN}
}

