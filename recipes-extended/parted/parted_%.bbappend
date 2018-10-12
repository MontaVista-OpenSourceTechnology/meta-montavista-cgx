inherit update-alternatives

ALTERNATIVE_${PN} += "partprobe"
ALTERNATIVE_LINK_NAME[partprobe] = "${sbindir}/partprobe"
