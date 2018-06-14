PR .= ".1"

inherit multilib-alternatives ship-recipe-sources
MULTILIB_ALTERNATIVES_${PN} = "${bindir}/libtool ${bindir}/libtoolize"

