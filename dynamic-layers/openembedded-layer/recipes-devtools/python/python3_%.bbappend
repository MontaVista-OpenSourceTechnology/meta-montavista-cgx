PR .= ".4"

FILESEXTRAPATHS_prepend := "${THISDIR}/python3:"

export READELF="${HOST_PREFIX}readelf"

do_install_append_class-target () {
       if [ -L "${D}${bindir}/python3" ] ; then
               rm ${D}${bindir}/python3
               install -m 0755 ${D}${bindir}/python3.7 ${D}${bindir}/python3
       fi
}
#inherit multilib-alternatives
#
#MULTILIB_ALTERNATIVES_${PN}-core_class-target = "${bindir}/python3.5m-config ${bindir}/python3"
#py_package_preprocess_prepend_class-target () {
#     ln -s python3.5m-config.${PN} ${PKGD}/${bindir}/python${PYTHON_BINABI}-config
#}
#
#py_package_preprocess_append_class-target () {
#     rm ${PKGD}/${bindir}/python${PYTHON_BINABI}-config
#}
