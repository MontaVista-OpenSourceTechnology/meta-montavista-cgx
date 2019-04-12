inherit multilib_script multilib_header
MULTILIB_SCRIPTS = "${PN}:${bindir}/prxs"

do_install_append () {
    oe_multilib_header proftpd/config.h proftpd/buildstamp.h
}
