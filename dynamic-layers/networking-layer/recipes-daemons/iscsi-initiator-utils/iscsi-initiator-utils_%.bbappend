PR .= ".1"

#FIXME: need to fix string truncate warnings
do_compile_prepend () {
     sed -i ${S}/libopeniscsiusr/Makefile -e "s,-Werror,,"
} 
