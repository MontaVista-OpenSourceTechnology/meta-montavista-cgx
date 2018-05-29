inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}-server = "${bindir}/mysqld_safe"
MULTILIB_ALTERNATIVES_${PN}-client = "${bindir}/mysqlbug"
MULTILIB_ALTERNATIVES_libmysqlclient-dev = "${bindir}/mysql_config"
MULTILIB_HEADERS = "mysql/my_config.h mysql/private/config.h"
