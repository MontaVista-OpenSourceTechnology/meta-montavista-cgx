inherit multilib_header

do_install_append () {
    oe_multilib_header quagga/version.h
}
