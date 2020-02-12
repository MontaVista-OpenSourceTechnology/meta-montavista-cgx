PR .= ".1"
inherit multilib_script

MULTILIB_SCRIPTS = "${PN}:/opt/lsb-test/packages_list \
                    ${PN}:/opt/lsb-test/session"
