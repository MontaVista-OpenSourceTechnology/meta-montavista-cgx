PR .= ".1"

do_compile_prepend () {
   touch ${S}/po/systemtap.pot ${S}/po/*.po ${S}/po/*.gmo
}
