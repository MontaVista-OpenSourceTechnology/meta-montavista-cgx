
SUMMARY = "Additional packages for security profile"
DESCRIPTION = "Additional packages for security profile"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
         packagegroup-profile-security \
"

RDEPENDS_packagegroup-profile-security = " \
         packagegroup-core-selinux \
         packagegroup-tpm \
         packagegroup-core-security \ 
" 
