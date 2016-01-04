PR .= ".1"

postinst_prologue_prepend () {
exit 0
}

RDEPENDS_${PN}-ptest += "cantarell-fonts"
