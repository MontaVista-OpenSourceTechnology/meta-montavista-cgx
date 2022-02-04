RDEPENDS:${SRCNAME}-apache:remove = "memcached"
RDEPENDS:${SRCNAME}-apache:append = " ${@bb.utils.contains('COMPATIBLE_HOST','${TUNE_PKGARCH}',' memcached ','', d)} "
