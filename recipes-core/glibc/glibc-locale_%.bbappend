PR .= ".1"

do_install_append () {
    if [ "x${MLPREFIX}" != "x" ] ; then
        mv ${D}${datadir}/i18n/charmaps/CP1255.gz ${D}${datadir}/i18n/charmaps/${MLPREFIX}-CP1255.gz
        mv ${D}${datadir}/i18n/charmaps/INVARIANT.gz ${D}${datadir}/i18n/charmaps/${MLPREFIX}-INVARIANT.gz
        mv ${D}${datadir}/i18n/charmaps/UTF-8.gz ${D}${datadir}/i18n/charmaps/${MLPREFIX}-UTF-8.gz
    fi
}
