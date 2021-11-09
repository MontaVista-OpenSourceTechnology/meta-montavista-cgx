
SUMMARY = "Additional packages for base profile"
DESCRIPTION = "Additional packages for base profile"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
         packagegroup-profile-base \
"

RDEPENDS:packagegroup-profile-base = " \
         packagegroup-additional-oe-tools \
" 
