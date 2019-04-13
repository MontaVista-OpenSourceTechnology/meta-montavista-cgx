PR .= ".1"

do_install_append () {
     install -d ${D}/selinux
}
