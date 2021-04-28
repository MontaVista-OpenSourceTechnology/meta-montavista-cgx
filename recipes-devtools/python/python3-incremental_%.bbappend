PR .= ".1"

BBCLASSEXTEND += "native"
RDEPENDS_${PN}_class-target += " \
     ${PYTHON_PN}-twisted \
     ${PYTHON_PN}-click \
"
RDEPENDS_${PN}_class-native += " \
     ${PYTHON_PN}-click \
"

