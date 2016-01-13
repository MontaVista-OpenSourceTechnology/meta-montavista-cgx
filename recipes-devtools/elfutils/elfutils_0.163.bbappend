PR .= ".1"

FILESEXTRAPATHS_append := "${THISDIR}/files"

SRC_URI += "file://elfutils-futimes.diff \
            file://elfutils-163-handle-missing-SHF_INFO_LINK.patch"

EXTRA_OECONF_append_class-native = " --disable-werror"
EXTRA_OEMAKE_append_class-native = " readelf_no_Werror='no' strings_no_Werror='no' ldlex_no_Werror='no' "
EXTRA_OECONF_append = " --disable-werror "
EXTRA_OEMAKE_append = " readelf_no_Werror='no' strings_no_Werror='no' ldlex_no_Werror='no' "

do_compile_prepend () {
      sed -i ${B}/src/Makefile -e "s,-Werror,,"
}
