PR .= ".6"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://mcs-sshd \
            file://mcs-sshd_config \
	    file://Add_1024-bit-group-primes-for-DH-key-exchange.patch \
	   "

do_install_append() {
    if ${@base_contains('DISTRO_FEATURES', 'OpenLDAP', 'true', 'false', d)}; then
        install -D -m 644 ${WORKDIR}/mcs-sshd ${D}/etc/pam.d/sshd
        install -D -m 644 ${WORKDIR}/mcs-sshd_config ${D}/etc/ssh/sshd_config
    fi
}
