SRC_URI += " \
       file://0001-postfix-Don-t-warn-on-links.patch \
       file://0001-Switch-runtime-test-to-compile-test.patch \
"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}  = "${sysconfdir}/postfix/makedefs.out"

libexecdir="${prefix}/libexec/postfix"
