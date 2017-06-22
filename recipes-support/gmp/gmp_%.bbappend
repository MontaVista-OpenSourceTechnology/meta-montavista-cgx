PR .= ".2"

inherit multilib_header

do_install_append () {
        oe_multilib_header gmp.h
}

TARGET_ARCH_task-configure_linux-gnuilp32 = "none"
