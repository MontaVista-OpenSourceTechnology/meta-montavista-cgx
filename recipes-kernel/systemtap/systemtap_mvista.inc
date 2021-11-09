PR .= ".1"

do_compile:prepend () {
   touch ${S}/po/systemtap.pot ${S}/po/*.po ${S}/po/*.gmo
}
