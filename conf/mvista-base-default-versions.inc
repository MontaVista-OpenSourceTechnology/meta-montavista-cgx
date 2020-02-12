#
# Initialize BBMASK to some value, so that the subsequent masks 
# gets added after this value.
BBMASK ?= "(catchemptybbmask)"
BBMASK += "meta-clang/recipes-core/packagegroups/packagegroup-core-standalone-sdk-target.bbappend"
#FIXME: This bbappend is broken in master.
BBMASK += "meta-openstack/recipes-dbs/postgresql/postgresql_%.bbappend"

