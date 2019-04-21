PR .= ".1"

inherit multilib_script
MULTILIB_SCRIPTS = "${PN}:${libexecdir}/mc/extfs.d/iso9660 ${PN}:${datadir}/mc/syntax/Syntax"
