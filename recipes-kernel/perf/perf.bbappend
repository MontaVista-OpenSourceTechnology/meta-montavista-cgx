PR .= ".1"

do_configure_prepend () {
    if [ -e "${S}/tools/perf/util/libunwind/x86_32.c" ] ; then
        grep -q "#include <error.h>" ${S}/tools/perf/util/libunwind/x86_32.c ||
        sed -i 's:#include "unwind.h":#include <errno.h>\n#include "unwind.h":g' \
        ${S}/tools/perf/util/libunwind/x86_32.c
    fi
}
