DEPENDS_class-native = "libxslt-native libcroco-native"

do_configure_prepend () {
       sed -i "s:; \$(GEN_MANPAGE)::g" ${S}/Makefile.in ${S}/Makefile.am
}
