require ${@bb.utils.contains('DISTRO_FEATURES', 'mvista-base', '${BPN}-native_mvista.inc', '', d)}
