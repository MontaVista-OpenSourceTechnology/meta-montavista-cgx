USE_SYSTEMD = "1"
DISTRO_FEATURES_append = " systemd "
DISTRO_FEATURES_remove = "sysvinit"
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = "systemd-compat-units"

SAVE_DISTRO := "${DISTRO}"
SAVE_DISTRO_NAME := "${DISTRO_NAME}"
include conf/distro/lmp.conf
DISTRO := "${SAVE_DISTRO}"
DISTRO_NAME := "${SAVE_DISTRO_NAME}"
OVERRIDES_append = ":lmp:lmp-base"

IMAGE_BOOT_FILES_rpi_prepend = "bootfiles/* "

ERROR_QA_remove = "installed-vs-shipped"

