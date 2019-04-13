PACKAGE_INSTALL_remove = "ovmf-shell-efi"
PACKAGE_INSTALL_append += "${@bb.utils.contains('COMPATIBLE_HOST', '${TUNE_PKGARCH}', ' ovmf-shell-efi ', '', d)}"
