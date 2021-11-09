USE_SYSTEMD = "1"
DISTRO_FEATURES:append = " systemd "
DISTRO_FEATURES:remove = "sysvinit"
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = "systemd-compat-units"

SAVE_DISTRO := "${DISTRO}"
SAVE_DISTRO_NAME := "${DISTRO_NAME}"
include conf/distro/lmp.conf
DISTRO := "${SAVE_DISTRO}"
DISTRO_NAME := "${SAVE_DISTRO_NAME}"
OVERRIDES:append = ":lmp"

IMAGE_BOOT_FILES_rpi:prepend = "bootfiles/* "

ERROR_QA:remove = "installed-vs-shipped"

PR:pn-mvl-support = "3.4.0"
