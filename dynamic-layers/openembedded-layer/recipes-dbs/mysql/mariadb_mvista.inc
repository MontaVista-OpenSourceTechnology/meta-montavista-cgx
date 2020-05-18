PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_riscv64 = " file://0001-libmysql-Do-not-export-_fini-_init-on-risc-v.patch"
SRC_URI_append_riscv = " file://0001-libmysql-Do-not-export-_fini-_init-on-risc-v.patch"

inherit multilib_script multilib_header

MULTILIB_SCRIPTS = " \
                    ${PN}-server:${bindir}/mysqld_safe \
                    libmysqlclient-dev:${bindir}/mysql_config \
                    ${PN}-server:${bindir}/mysql_install_db"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

FILES_${PN} += "${localstatedir}/lib/mysql"
do_install_append () {
   chown mysql.mysql ${D}${bindir}/mysqld_safe_helper
   chmod 4755 ${D}${bindir}/mysqld_safe_helper
   mkdir -p ${D}${localstatedir}/lib/mysql
   chown mysql.mysql ${D}${localstatedir}/lib/mysql
   oe_multilib_header mysql/my_config.h
   oe_multilib_header mysql/server/my_config.h mysql/server/private/config.h mysql/mariadb_version.h
} 
