PR .= ".1"

do_install_append () {
    # Disable dnsmasq starting DNS server during boot up
    sed -i "s:/usr/bin/dnsmasq:/usr/bin/dnsmasq --port=0:g" \
    ${D}${sysconfdir}/init.d/libvirtd
}
