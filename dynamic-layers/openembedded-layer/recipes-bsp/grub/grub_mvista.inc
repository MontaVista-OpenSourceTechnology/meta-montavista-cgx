PR .= ".3"

PACKAGECONFIG_append = "libdevmapper"
PACKAGECONFIG[libdevmapper] = "--enable-device-mapper,--disable-device-mapper,libdevmapper"

RDEPENDS_${PN} += "libdevmapper"
