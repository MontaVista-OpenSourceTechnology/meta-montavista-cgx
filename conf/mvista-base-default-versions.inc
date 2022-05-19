#
# Initialize BBMASK to some value, so that the subsequent masks 
# gets added after this value.
BBMASK ?= "(catchemptybbmask)"
BBMASK += "meta-clang/recipes-core/packagegroups/packagegroup-core-standalone-sdk-target.bbappend"
#FIXME: This bbappend is broken in master.
BBMASK += "meta-openstack/recipes-dbs/postgresql/postgresql_%.bbappend"

PACKAGECONFIG:pn-qemu ?= "libusb \
                          virtfs \
                          kvm \
                          fdt \
                          sdl \
                          bzip2 \
                          ${@bb.utils.filter('DISTRO_FEATURES', 'alsa xen', d)} \
"
PACKAGECONFIG:pn-lib32-qemu = "${PACKAGECONFIG:pn-qemu}"
PACKAGECONFIG:pn-lib64-qemu = "${PACKAGECONFIG:pn-qemu}"
