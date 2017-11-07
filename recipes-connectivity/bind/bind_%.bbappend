inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "${bindir}/bind9-config ${bindir}/isc-config.sh"
MULTILIB_HEADERS = "isc/platform.h"

