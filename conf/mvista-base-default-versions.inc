#
# Initialize BBMASK to some value, so that the subsequent masks 
# gets added after this value.
BBMASK ?= "(catchemptybbmask)"
BBMASK += "meta-clang/recipes-core/packagegroups/packagegroup-core-standalone-sdk-target.bbappend"
#FIXME: This bbappend is broken in master.
BBMASK += "meta-openstack/recipes-dbs/postgresql/postgresql_%.bbappend"

PACKAGECONFIG_pn-qemu ?= "libusb \
                          virtfs \
                          kvm \
                          fdt \
                          sdl \
                          bzip2 \
                          ${@bb.utils.filter('DISTRO_FEATURES', 'alsa xen', d)} \
"
PACKAGECONFIG_pn-lib32-qemu = "${PACKAGECONFIG_pn-qemu}"
PACKAGECONFIG_pn-lib64-qemu = "${PACKAGECONFIG_pn-qemu}"
# Clang sets preferred version and provider for llvm. But version is checked before the provide is taken in to account.
# Add to clean up warning, with clang, it still picks up clang 10.0.1

PREFERRED_VERSION_llvm="9.0.1"
PREFERRED_VERSION_llvm-native="9.0.1"
