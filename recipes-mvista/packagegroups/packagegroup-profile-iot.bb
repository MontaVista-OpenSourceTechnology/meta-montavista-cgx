
SUMMARY = "Additional packages for iot profile"
DESCRIPTION = "Additional packages for iot profile"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
         packagegroup-profile-iot \
"

RDEPENDS_packagegroup-profile-iot = " \
         lua \
" 
