do_compile_prepend_linux-gnuilp32 () {
export NSS_ENABLE_WERROR=0
}

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "${sysconfdir}/pki/nssdb/key3.db ${sysconfdir}/pki/nssdb/secmod.db"

