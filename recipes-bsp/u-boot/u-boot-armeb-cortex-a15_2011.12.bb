# The armeb u-boot requires a little endian toolchain to build.
# To avoid this requirement for this single pacakge we are proviiding a binary
# version of the u-boot built from the arm-cortex-a15 build to be provided in the 
# armeb build.
#
# To rebuild binary add MACHINE="arm-cortex-a15", and install the little endian compiler
# and exectute:
# bitbake u-boot
#

include u-boot-arm-cortex-a15_2011.12.bb
COMPATIBLE_MACHINE = "armeb-cortex-a15"

SRC_URI += "file://u-boot.bin-arm-cortex-a15"

do_compile () {

cp ${WORKDIR}/u-boot.bin-arm-cortex-a15 ${S}/u-boot.bin

}


