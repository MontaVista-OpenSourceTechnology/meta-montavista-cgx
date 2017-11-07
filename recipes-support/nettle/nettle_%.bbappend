PR .= ".1"
inherit multilib-alternatives

MULTILIB_HEADERS = "nettle/nettle-stdint.h nettle/version.h"

EXTRA_OECONF += "--enable-mini-gmp=no"
