PR .= ".1"

inherit multilib_header

do_install_append () {
    oe_multilib_header assuan.h
}
