PR .= ".1"

do_install_append () {
    # Disable dnsmasq starting DHCP and DNS server 
    sed -i "s:^dhcp-range:#dhcp-range:g" ${D}${sysconfdir}/dnsmasq.conf
    sed -i 's:\(^ARGS=\"\):\1--port=0 :g' ${D}${sysconfdir}/init.d/dnsmasq
    sed -i "s:\(^ExecStart=/usr/bin/dnsmasq\):\1 --port=0:g" \
    ${D}${systemd_unitdir}/system/dnsmasq.service
}
