# Prefer building u-boot-socfpga v2019.01 recipe, as v2017.09 recipe
# does not compile with dtc v1.4.7 (present in thud).
PREFERRED_VERSION_u-boot-socfpga_stratix10 ?= "v2019.01"

# The u-boot-socfpga v2019.01 generated u-boot-spl.bin and
# u-boot.img, instead of u-boot-spl-dtb.bin and u-boot-dtb.img;
# hence change SPL_BINARY and UBOOT_BINARY accordingly.

SPL_BINARY_stratix10 = "spl/u-boot-spl.bin"
UBOOT_BINARY_stratix10 = "u-boot.img"

IMAGE_BOOT_FILES_remove_stratix10 = "u-boot-dtb.${UBOOT_SUFFIX}"
IMAGE_BOOT_FILES_append_stratix10 = " u-boot.${UBOOT_SUFFIX} "
