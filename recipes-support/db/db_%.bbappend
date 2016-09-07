PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://db.h"

do_install_append () {
    if [ "${SITEINFO_BITS}" == "64" ] ; then
        mv ${D}${includedir}/db60/db.h \
        ${D}${includedir}/db60/db-64.h
        ln -s db60/db-64.h ${D}${includedir}/db-64.h
    else
        mv ${D}${includedir}/db60/db.h \
        ${D}${includedir}/db60/db-32.h
        ln -s db60/db-32.h ${D}${includedir}/db-32.h
    fi
    install -m 0644 ${WORKDIR}/db.h ${D}${includedir}/db60/db.h
}
