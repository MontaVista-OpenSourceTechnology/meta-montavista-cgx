PR .= ".3"

PACKAGECONFIG_append = "libdevmapper"
PACKAGECONFIG[libdevmapper] = "--enable-device-mapper,--disable-device-mapper,lvm2"

RDEPENDS_${PN} += "libdevmapper"
