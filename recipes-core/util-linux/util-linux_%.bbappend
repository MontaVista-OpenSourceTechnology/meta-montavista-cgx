ALTERNATIVE_${PN} += "nsenter fsfreeze fallocate unshare"

ALTERNATIVE_LINK_NAME[nsenter] = "${bindir}/nsenter"
ALTERNATIVE_LINK_NAME[fsfreeze] = "${sbindir}/fsfreeze"
ALTERNATIVE_LINK_NAME[fallocate] = "${bindir}/fallocate"
ALTERNATIVE_LINK_NAME[unshare] = "${bindir}/unshare"
