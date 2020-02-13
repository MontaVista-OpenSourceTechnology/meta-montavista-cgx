PR .= ".1"

#FIXME: this shouldn't be needed
pkg_postinst_ontarget_${PN} () {
    udevadm hwdb --update
}

