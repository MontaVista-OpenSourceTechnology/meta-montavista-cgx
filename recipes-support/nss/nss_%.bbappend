PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-Subject-PATCH-Fix-SHA_HTONL-bug-for-arm-32be.patch"

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}_class-target = "${sysconfdir}/pki/nssdb/key3.db ${sysconfdir}/pki/nssdb/secmod.db"

