PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://tiffconf.h"

do_install_append () {
    if [ "${SITEINFO_BITS}" == "64" ] ; then
        mv ${D}${includedir}/tiffconf.h \
        ${D}${includedir}/tiffconf-64.h
    else
        mv ${D}${includedir}/tiffconf.h \
        ${D}${includedir}/tiffconf-32.h
    fi
    install -m 0644 ${WORKDIR}/tiffconf.h ${D}${includedir}/tiffconf.h
}
