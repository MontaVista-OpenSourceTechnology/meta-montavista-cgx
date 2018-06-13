PR .= ".1"

EXTRA_OECONF_append += "--mandir=${datadir}/${PN}/man"

FILES_${PN}-doc += "${datadir}/${PN}/man"

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}-dev = "${bindir}/gpgrt-config"
