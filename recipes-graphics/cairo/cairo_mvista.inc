PR .= ".1"

PACKAGES =+ "cairo-perf-utils-bin"
FILES_${PN}-perf-utils-bin += "${bindir}/cairo-trace"
RDEPENDS_${PN}-perf-utils-bin += "${PN}-perf-utils"
