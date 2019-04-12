PR .= ".1"

SRC_URI += " \
       file://0001-postfix-Don-t-warn-on-links.patch \
       file://0001-Switch-runtime-test-to-compile-test.patch \
"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

CCARGS_append_virtclass-native = " -DNO_NIS "
AUXLIBS_append_virtclass-native = " -lresolv"

libexecdir="${prefix}/libexec/postfix"
