PR .= ".1"

REQUIRED_DISTRO_FEATURES = ""

DEPENDS = "openssl"

inherit systemd autotools-brokensep update-rc.d

do_install_append () {
    install -D -m 755 ${S}/etc/openisns.init ${D}${sysconfdir}/init.d/openisns
    sed -i 's|daemon isnsd|start-stop-daemon --start --quiet --oknodo --exec ${sbindir}/isnsd --|' \
        ${D}${sysconfdir}/init.d/openisns
}

INITSCRIPT_NAME = "openisns"
