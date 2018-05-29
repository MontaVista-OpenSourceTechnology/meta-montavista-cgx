inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN}  = "${bindir}/pm-is-supported \
                                ${sbindir}/pm-suspend \
                                ${sbindir}/pm-hibernate \
                                ${sbindir}/pm-powersave \
                                ${sbindir}/pm-suspend-hybrid \
                               "
