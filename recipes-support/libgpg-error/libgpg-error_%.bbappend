PR .= ".1"

EXTRA_OECONF_append += "--mandir=${datadir}/${PN}/man"

inherit multilib-alternatives
MULTILIB_HEADERS = "gpg-error.h gpgrt.h"


FILES_${PN}-doc += "${datadir}/${PN}/man"
