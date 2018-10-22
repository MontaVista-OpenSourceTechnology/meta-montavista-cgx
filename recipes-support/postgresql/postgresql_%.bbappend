PR .= ".1"

# Make sure postgresql server starts at all run levels
# Character 'S' is absent in meta-oe's postgresql.inc
INITSCRIPT_PARAMS_${PN} = "start 64 S . stop 36 0 1 2 3 4 5 6 ."

inherit multilib-alternatives
MULTILIB_HEADERS = "pg_config.h pg_config_ext.h"

