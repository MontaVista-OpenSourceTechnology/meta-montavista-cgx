PR .= ".1"

# MySQL daemon (from mariadb-server) starts successfully only if
# a valid/default mysql5 database exists. So, make sure to pull
# mariadb-setupdb package to install/create mysql5 database.
RDEPENDS_${PN}-server += "${PN}-setupdb"
