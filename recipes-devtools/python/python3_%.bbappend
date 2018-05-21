PR .= ".4"

FILESEXTRAPATHS_prepend := "${THISDIR}/python3:"

export READELF="${HOST_PREFIX}readelf"

do_install_append_class-target () {
       if [ -L "${D}${bindir}/python3" ] ; then
               rm ${D}${bindir}/python3
               install -m 0755 ${D}${bindir}/python3.5 ${D}${bindir}/python3
       fi
}
inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}-core  = "${bindir}/python3.5m-config ${bindir}/python3"
