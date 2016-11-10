PR .= ".2"

FILESEXTRAPATHS_append := "${THISDIR}/files"

SRC_URI += "file://elfutils-futimes.diff \
            "
EXTRA_OEMAKE_append_class-native = " readelf_no_Werror='no' strings_no_Werror='no' ldlex_no_Werror='no' "
EXTRA_OEMAKE_append = " readelf_no_Werror='no' strings_no_Werror='no' ldlex_no_Werror='no' "

do_compile_prepend () {
      sed -i ${B}/src/Makefile -e "s,-Werror,,"
}
