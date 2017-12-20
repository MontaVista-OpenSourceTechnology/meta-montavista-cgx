inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}-dev = "${bindir}/net-snmp-config ${bindir}/net-snmp-create-v3-user"
MULTILIB_HEADERS = "net-snmp/net-snmp-config.h"

net_snmp_sysroot_preprocess () {
    if [ -e ${D}${bindir}/net-snmp-config.${PN} ]; then
        install -d ${SYSROOT_DESTDIR}${bindir_crossscripts}/
        install -m 755 ${D}${bindir}/net-snmp-config.${PN} ${SYSROOT_DESTDIR}${bindir_crossscripts}/net-snmp-config
        sed -e "s@-I/usr/include@-I${STAGING_INCDIR}@g" \
            -e "s@^prefix=.*@prefix=${STAGING_DIR_HOST}${prefix}@g" \
            -e "s@^exec_prefix=.*@exec_prefix=${STAGING_EXECPREFIXDIR}@g" \
            -e "s@^includedir=.*@includedir=${STAGING_INCDIR}@g" \
            -e "s@^libdir=.*@libdir=${STAGING_LIBDIR}@g" \
            -e "s@^NSC_SRCDIR=.*@NSC_SRCDIR=${S}@g" \
          -i  ${SYSROOT_DESTDIR}${bindir_crossscripts}/net-snmp-config
    fi
}

