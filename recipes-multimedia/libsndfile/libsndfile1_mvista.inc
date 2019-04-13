PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://sndfile.h"

do_install_append () {
    if [ "${SITEINFO_BITS}" == "64" ] ; then
        mv ${D}${includedir}/sndfile.h \
        ${D}${includedir}/sndfile-64.h
    else
        mv ${D}${includedir}/sndfile.h \
        ${D}${includedir}/sndfile-32.h
    fi
    install -m 0644 ${WORKDIR}/sndfile.h ${D}${includedir}/sndfile.h
}
