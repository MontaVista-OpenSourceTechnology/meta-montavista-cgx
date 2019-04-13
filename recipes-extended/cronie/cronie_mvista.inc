PR .= ".1"
inherit update-alternatives
ALTERNATIVE_PRIORITY = "50"

ALTERNATIVE_${PN} = "crontab"
ALTERNATIVE_LINK_NAME[crontab] = "${bindir}/crontab"
