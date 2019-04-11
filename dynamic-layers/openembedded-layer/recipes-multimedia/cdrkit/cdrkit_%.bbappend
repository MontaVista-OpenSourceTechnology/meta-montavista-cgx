PR .= ".1"

# Some test scripts use mkisofs to create ISO image, so create
# symlink to genisoimage.
do_install_append () {
    ln -sf genisoimage ${D}${bindir}/mkisofs
}
