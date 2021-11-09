PR .= ".3"

PACKAGECONFIG:append = "libdevmapper"
PACKAGECONFIG[libdevmapper] = "--enable-device-mapper,--disable-device-mapper,lvm2"

RDEPENDS:${PN} += "libdevmapper"
