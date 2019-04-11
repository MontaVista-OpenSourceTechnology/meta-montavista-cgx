inherit multilib_script multilib_header

MULTILIB_SCRIPTS = "${PN}-client:${bindir}/mysqlbug \
                    ${PN}-server:${bindir}/mysqld_safe \
                    libmysqlclient-dev:${bindir}/mysql_config"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

FILES_${PN} += "${localstatedir}/lib/mysql"
do_install_append () {
   chown mysql.mysql ${D}${bindir}/mysqld_safe_helper
   chmod 4755 ${D}${bindir}/mysqld_safe_helper
   mkdir -p ${D}${localstatedir}/lib/mysql
   chown mysql.mysql ${D}${localstatedir}/lib/mysql
   oe_multilib_header mysql/my_config.h mysql/private/config.h
} 
