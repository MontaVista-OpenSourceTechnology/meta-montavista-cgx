PR .= ".1"

do_install_append () {
    # WORKDIR is populated in the comment section, so ignore it.
    sed -i -e "s:${WORKDIR}::g" \
        ${D}${includedir}/gdk-pixbuf-2.0/gdk-pixbuf/gdk-pixbuf-marshal.h
}
