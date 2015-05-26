include conf/machine/include/tune-cortexa15.inc

AVAILTUNES += "cortexa15hfb cortexa15thfb"

ARMPKGARCH_tune-cortexa15hfb = "cortexa15"
ARMPKGARCH_tune-cortexa15thfb = "cortexa15"
TUNE_FEATURES_tune-cortexa15hfb ?= "${TUNE_FEATURES_tune-armv7ahf} cortexa15 bigendian"
TUNE_FEATURES_tune-cortexa15thfb ?= "${TUNE_FEATURES_tune-armv7athf} cortexa15 bigendian"
PACKAGE_EXTRA_ARCHS_tune-cortexa15hfb = "${PACKAGE_EXTRA_ARCHS_tune-armv7ahfb} cortexa15hfb-vfp"
PACKAGE_EXTRA_ARCHS_tune-cortexa15thfb = "${PACKAGE_EXTRA_ARCHS_tune-armv7athfb} cortexa15hfb-vfp cortexa15t2hfb-vfp"
