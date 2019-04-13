RDEPENDS_${SRCNAME}-apache_remove = "memcached"
RDEPENDS_${SRCNAME}-apache_append += "${@bb.utils.contains('COMPATIBLE_HOST','${TUNE_PKGARCH}',' memcached ','', d)}"
