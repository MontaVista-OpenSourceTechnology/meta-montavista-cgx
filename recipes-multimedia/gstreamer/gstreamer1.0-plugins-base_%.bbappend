PR .= ".1"

do_install_append () {
    # WORKDIR is populated in the comment section, so ignore it.
    sed -i -e "s:${WORKDIR}::g" \
        ${D}${includedir}/gstreamer-1.0/gst/rtsp/gstrtsp-enumtypes.h 
}
