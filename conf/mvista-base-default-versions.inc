#
# Initialize BBMASK to some value, so that the subsequent masks 
# gets added after this value.
BBMASK ?= "(catchemptybbmask)"
MVLBASE='${@os.path.normpath("${LAYERDIR}/")}'
BBMASK += "meta-clang/recipes-core/packagegroups/packagegroup-core-standalone-sdk-target.bbappend"


PREFERRED_VERSION_strace ??= "4.24"
PREFERRED_VERSION_u-boot-fw-utils ??= "2018.07"
