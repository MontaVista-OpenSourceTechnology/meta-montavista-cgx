PR .= ".2"

RDEPENDS_${PN}-bin += "${PN}-src"

DEPENDS += "${PYTHON_PN}-incremental-native"
