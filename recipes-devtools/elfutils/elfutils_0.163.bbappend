FILESEXTRAPATHS_append := "${THISDIR}/files"

SRC_URI += "file://elfutils-futimes.diff"
EXTRA_OECONF_append_class-native = "--disable-werror"
EXTRA_OEMAKE_append_class-native = "readelf_no_Werror='no' strings_no_Werror='no' ldlex_no_Werror='no'"

do_compile_class-native_prepend () {
      sed -i ${B}/src/Makefile -e "s,-Werror,,"
}
