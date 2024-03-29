PR .= ".1"


inherit multilib_script multilib_header

MULTILIB_SCRIPTS = " \
                    ${PN}-server:${bindir}/mysqld_safe \
                    ${PN}-server:${bindir}/mariadbd-safe \
                    libmysqlclient-dev:${bindir}/mysql_config \
                    ${PN}-server:${bindir}/mariadb-install-db \
                    ${PN}-server:${bindir}/mysql_install_db"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILES:${PN} += "${localstatedir}/lib/mysql"
do_install:append () {
   chown mysql.mysql ${D}${bindir}/mysqld_safe_helper
   chmod 4755 ${D}${bindir}/mysqld_safe_helper
   mkdir -p ${D}${localstatedir}/lib/mysql
   chown mysql.mysql ${D}${localstatedir}/lib/mysql
   oe_multilib_header mysql/my_config.h
   oe_multilib_header mysql/server/my_config.h mysql/server/private/config.h mysql/mariadb_version.h
} 
