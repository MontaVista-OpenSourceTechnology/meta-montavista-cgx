inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "${sbindir}/envvars \
                               ${sbindir}/envvars-std \
                               ${sysconfdir}/init.d/apache2 \
                               ${sysconfdir}/apache2/httpd.conf \
                               ${datadir}/apache2/build/config.nice \
                               ${datadir}/apache2/build/config_vars.mk"

MULTILIB_HEADERS = "apache2/ap_config_layout.h"

