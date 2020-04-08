require ${@bb.utils.contains('DISTRO_FEATURES', 'mvista-base', 'qemu_mvista.inc', '', d)}
