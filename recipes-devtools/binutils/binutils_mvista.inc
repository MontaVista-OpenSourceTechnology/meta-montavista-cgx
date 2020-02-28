PR .= ".1"
inherit multilib_header

do_install_append_class-target () {
  oe_multilib_header bfd_stdint.h
}
