inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}-server = "${bindir}/mysqld_safe"
MULTILIB_ALTERNATIVES_${PN}-client = "${bindir}/mysqlbug"
MULTILIB_ALTERNATIVES_libmysqlclient-dev = "${bindir}/mysql_config"
MULTILIB_HEADERS = "mysql/my_config.h mysql/private/config.h"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

FILES_${PN} += "${localstatedir}/lib/mysql"
do_install_append () {
   chown mysql.mysql ${D}${bindir}/mysqld_safe_helper
   chmod 4755 ${D}${bindir}/mysqld_safe_helper
   mkdir -p ${D}${localstatedir}/lib/mysql
   chown mysql.mysql ${D}${localstatedir}/lib/mysql
} 
