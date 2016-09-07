PR .= ".1"

# Remove stale .pyo files
do_install_append () {
    for iter in `find ${D} | grep "\.pyo$"` ; do
        rm $iter
    done
}
