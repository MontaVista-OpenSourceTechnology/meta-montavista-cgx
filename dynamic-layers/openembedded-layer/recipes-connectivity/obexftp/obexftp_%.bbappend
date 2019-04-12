PR .= ".1"

do_configure_prepend () {
    sed -i -e "s: \${OpenObex_LIBRARIES}:-lopenobex:g" -e "s: openobex: -lopenobex:g" \
    ${S}/obexftp/CMakeLists.txt ${S}/multicobex/CMakeLists.txt \
    ${S}/apps/CMakeLists.txt
}
