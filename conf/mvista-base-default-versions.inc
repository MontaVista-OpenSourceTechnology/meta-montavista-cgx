#
# Initialize BBMASK to some value, so that the subsequent masks 
# gets added after this value.
BBMASK ?= "(catchemptybbmask)"
BBMASK += "meta-clang/recipes-core/packagegroups/packagegroup-core-standalone-sdk-target.bbappend"
#FIXME: This bbappend is broken in master.
BBMASK += "meta-openstack/recipes-dbs/postgresql/postgresql_%.bbappend"
PREFERRED_VERSION_u-boot-fw-utils ?= "2019.04"
PREFERRED_VERSION_u-boot ?= "2019.04"
PREFERRED_VERSION_u-boot-tools ?= "2019.04"

QEMUVERSION_riscv64 ?= "4.0%"
QEMUVERSION_riscv ?= "4.0%"
