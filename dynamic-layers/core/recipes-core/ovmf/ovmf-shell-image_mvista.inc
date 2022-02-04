PACKAGE_INSTALL:remove = "ovmf-shell-efi"
PACKAGE_INSTALL:append = " ${@bb.utils.contains('COMPATIBLE_HOST', '${TUNE_PKGARCH}', ' ovmf-shell-efi ', '', d)} "
