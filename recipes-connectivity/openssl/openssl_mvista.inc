PR .= ".2"

# MD2 is required by ipmiutil
EXTRA_OECONF += 'enable-md2'
RDEPENDS_${PN}_class-target += "rng-tools"

inherit multilib_script
MULTILIB_SCRIPTS = "${PN}-bin:${bindir}/c_rehash"
