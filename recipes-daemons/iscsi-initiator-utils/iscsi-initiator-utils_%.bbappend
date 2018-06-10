PR .= ".1"

REQUIRED_DISTRO_FEATURES = ""
#FIXME: need to fix string truncate warnings
do_compile_prepend () {
     sed -i ${S}/libopeniscsiusr/Makefile -e "s,-Werror,,"
} 
