inherit multilib_header

do_install_append () {
   oe_multilib_header json-glib-1.0/json-glib/json-enum-types.h
}
