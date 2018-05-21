PR .= ".1"

do_install_ptest_append () {
       sed -i "s:stat --format:/bin/stat.coreutils --format:g" \
       ${D}${PTEST_PATH}/tests/brief-vs-stat-zero-kernel-lies
}

RDEPENDS_${PN}-ptest += "coreutils"
