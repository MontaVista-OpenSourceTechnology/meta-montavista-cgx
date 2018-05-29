PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append () {
    # udev service fails to start , when /var/run is symbolic link to
    # /var/volatile/run directory; as /var/volatile/run directory
    # is created (via populate-volatile.sh) after udev script
    # is executed. So, let udev create control files in non-volatile /run
    # directory instead of /var/run.
    sed -i 's:^udev_run="/var/run/udev":udev_run="/run/udev":g' ${D}${sysconfdir}/udev/udev.conf

    mkdir -p ${D}${libdir}
    mv ${D}${datadir}/pkgconfig/* ${D}${libdir}/pkgconfig
    rm -rf ${D}${datadir}/pkgconfig
}
FILES_${PN}-dev += "${libdir}/pkgconfig/*.pc"

