PR .= ".1"
inherit multilib-alternatives

MULTILIB_ALTERNATIVES_${PN} = "${bindir}/xtrace  ${bindir}/sotruss"
