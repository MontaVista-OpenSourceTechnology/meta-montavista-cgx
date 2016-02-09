
SUMMARY = "Additional packages for iot profile"
DESCRIPTION = "Additional packages for iot profile"
PR = "r1"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
         packagegroup-profile-iot \
"

OPENJDK = " \
         openjdk-8 \
         classpath \
         classpath-common \
         classpath-examples \
         classpath-tools \
"

OPENJDK_aarch64 = ""

RDEPENDS_packagegroup-profile-iot = " \
         lua \
         ${OPENJDK} \
" 
