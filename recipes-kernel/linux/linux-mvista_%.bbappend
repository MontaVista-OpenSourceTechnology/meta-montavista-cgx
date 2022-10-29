include ${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'recipes-kernel/linux/linux-yocto_selinux.inc', '', d)}
