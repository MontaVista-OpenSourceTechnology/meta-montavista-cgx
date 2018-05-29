PR .= ".1"

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "/opt/ltp/testcases/bin/datafiles/bin.jmb \
                               /opt/ltp/testcases/bin/datafiles/bin.lg \
                               /opt/ltp/testcases/bin/datafiles/bin.med \
                               /opt/ltp/testcases/bin/datafiles/bin.sm \
                              "  
MULTILIB_ALTERNATIVES_${PN}-staticdev = "/opt/ltp/testcases/data/nm01/lib.a"
