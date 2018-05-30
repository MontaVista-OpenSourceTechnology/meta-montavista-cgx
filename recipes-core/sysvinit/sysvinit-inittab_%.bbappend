PR .= ".1"

do_install_append () {
       sed -i "s: vt102::g" ${D}${sysconfdir}/inittab
}
