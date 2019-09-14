PR .= ".2"

do_install_append_class-target () {
    mv ${D}${sysconfdir}/init.d/apache2 ${D}${sysconfdir}/apache2/apache2
    cat << EOF > ${D}${sysconfdir}/init.d/apache2
#! /bin/sh

# Start original apache2 script
. ${sysconfdir}/apache2/apache2

EOF
    chmod 0755 ${D}${sysconfdir}/init.d/apache2
    oe_multilib_header apache2/ap_config_layout.h
}

inherit multilib_script multilib_header
MULTILIB_SCRIPTS = " \
                    ${PN}:${sysconfdir}/apache2/httpd.conf \
                    ${PN}:${datadir}/apache2/build/config.nice \
                    ${PN}:${datadir}/apache2/build/config_vars.mk \
                    ${PN}:${sysconfdir}/apache2/extra/httpd-ssl.conf \
                    ${PN}:${sysconfdir}/apache2/apache2"
MULTILIB_HEADERS = "apache2/ap_config_layout.h"

FILES_${PN} += "${sysconfdir}/init.d/apache2"
apache_sysroot_preprocess () {
    install -d ${SYSROOT_DESTDIR}${bindir_crossscripts}/
    install -m 755 ${D}${bindir}/apxs ${SYSROOT_DESTDIR}${bindir_crossscripts}/
    install -d ${SYSROOT_DESTDIR}${sbindir}/
    install -m 755 ${D}${sbindir}/apachectl ${SYSROOT_DESTDIR}${sbindir}/
    sed -i 's!my $installbuilddir = .*!my $installbuilddir = "${STAGING_DIR_HOST}/${datadir}/${BPN}/build";!' ${SYSROOT_DESTDIR}${bindir_crossscripts}/apxs
    sed -i 's!my $libtool = .*!my $libtool = "${STAGING_BINDIR_CROSS}/${HOST_SYS}-libtool";!' ${SYSROOT_DESTDIR}${bindir_crossscripts}/apxs

    sed -i 's!^APR_CONFIG = .*!APR_CONFIG = ${STAGING_BINDIR_CROSS}/apr-1-config!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk
    sed -i 's!^APU_CONFIG = .*!APU_CONFIG = ${STAGING_BINDIR_CROSS}/apu-1-config!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk
    sed -i 's!^includedir = .*!includedir = ${STAGING_INCDIR}/apache2!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk
    sed -i 's!^CFLAGS = -I[^ ]*!CFLAGS = -I${STAGING_INCDIR}/openssl!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk
    sed -i 's!^EXTRA_LDFLAGS = .*!EXTRA_LDFLAGS = -L${STAGING_LIBDIR}!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk
    sed -i 's!^EXTRA_INCLUDES = .*!EXTRA_INCLUDES = -I$(includedir) -I. -I${STAGING_INCDIR}!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk
    sed -i 's!--sysroot=[^ ]*!--sysroot=${STAGING_DIR_HOST}!' ${SYSROOT_DESTDIR}${datadir}/${BPN}/build/config_vars.mk
}
