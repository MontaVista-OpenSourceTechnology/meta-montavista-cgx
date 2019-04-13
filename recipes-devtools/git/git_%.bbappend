require ${@bb.utils.contains('DISTRO_FEATURES', 'mvista-base', '${BPN}_mvista.inc', '', d)}
