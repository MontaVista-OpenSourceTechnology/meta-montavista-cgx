require ${@bb.utils.contains('DISTRO_FEATURES', 'mvista-base', 'clang-cross_mvista.inc', '', d)}
