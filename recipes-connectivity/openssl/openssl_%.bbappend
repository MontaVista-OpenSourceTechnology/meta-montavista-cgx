PR .= ".1"

# MD2 is required by ipmiutil
EXTRA_OECONF += 'enable-md2'
RDEPENDS_${PN}_class-target += "rng-tools"
