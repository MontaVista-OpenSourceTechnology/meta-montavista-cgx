# MIPS Architecture definition
# 12 defined ABIs, all combinations of:
# *) Big/Little Endian
# *) Hardware/Software Floating Point
# *) o32, n32, n64 ABI

DEFAULTTUNE ?= "mips"

# Endianess
TUNEVALID[bigendian] = "Enable big-endian mode"
TUNE_CCARGS += "${@bb.utils.contains("TUNE_FEATURES", "bigendian", "-meb", "-mel", d)}"

# ABI flags
TUNEVALID[o32] = "MIPS o32 ABI"
TUNECONFLICTS[o32] = "n32 n64"
TUNE_CCARGS += "${@bb.utils.contains("TUNE_FEATURES", "o32", "-mabi=32", "", d)}"

TUNEVALID[n32] = "MIPS64 n32 ABI"
TUNECONFLICTS[n32] = "o32 n64"
TUNE_CCARGS += "${@bb.utils.contains("TUNE_FEATURES", "n32", "-mabi=n32", "", d)}"

TUNEVALID[n64] = "MIPS64 n64 ABI"
TUNECONFLICTS[n64] = "o32 n32"
TUNE_CCARGS += "${@bb.utils.contains("TUNE_FEATURES", "n64", "-mabi=64", "", d)}"

# Floating point
TUNEVALID[fpu-hard] = "Use hardware FPU"
TUNE_CCARGS += "${@bb.utils.contains("TUNE_FEATURES", "fpu-hard", "-mhard-float", "-msoft-float", d)}"
TARGET_FPU = "${@bb.utils.contains("TUNE_FEATURES", "fpu-hard", "", "soft", d)}"

# Package naming
MIPSPKGSFX_ENDIAN = "${@bb.utils.contains("TUNE_FEATURES", "bigendian", "", "el", d)}"
MIPSPKGSFX_BYTE = "${@bb.utils.contains("TUNE_FEATURES", "n64" , "64", "", d)}"
MIPSPKGSFX_BYTE .= "${@bb.utils.contains("TUNE_FEATURES", "n32" , "64", "", d)}"
MIPSPKGSFX_FPU = "${@bb.utils.contains("TUNE_FEATURES", "fpu-hard" , "", "_nf", d)}"
MIPSPKGSFX_ABI = "${@bb.utils.contains("TUNE_FEATURES", "n32", "_n32", "", d)}"

TUNE_ARCH = "mips${MIPSPKGSFX_BYTE}${MIPSPKGSFX_ENDIAN}"
TUNE_PKGARCH = "${MIPSPKGSFX_VARIANT_tune-${DEFAULTTUNE}}${MIPSPKGSFX_FPU}${MIPSPKGSFX_ABI}"

# Base tunes
AVAILTUNES += "mips mips64_n32 mips64 mipsel mips64el_n32 mips64el mips_nf mips64_nf_n32 mips64_nf mipsel_nf mips64el_nf_n32 mips64el_nf"
TUNE_FEATURES_tune-mips = "o32 bigendian fpu-hard"
BASE_LIB_tune-mips = "lib"
MIPSPKGSFX_VARIANT_tune-mips = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mips = "mips"

TUNE_FEATURES_tune-mips64_n32 = "n32 bigendian fpu-hard"
BASE_LIB_tune-mips64_n32 = "lib32"
MIPSPKGSFX_VARIANT_tune-mips64_n32 = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mips64_n32 = "mips64_n32"

TUNE_FEATURES_tune-mips64 = "n64 bigendian fpu-hard"
BASE_LIB_tune-mips64 = "lib64"
MIPSPKGSFX_VARIANT_tune-mips64 = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mips64 = "mips64"

TUNE_FEATURES_tune-mipsel = "o32 fpu-hard"
BASE_LIB_tune-mipsel = "lib"
MIPSPKGSFX_VARIANT_tune-mipsel = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mipsel = "mipsel"

TUNE_FEATURES_tune-mips64el_n32 = "n32 fpu-hard"
BASE_LIB_tune-mips64el_n32 = "lib32"
MIPSPKGSFX_VARIANT_tune-mips64el_n32 = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mips64el_n32 = "mips64el_n32"

TUNE_FEATURES_tune-mips64el = "n64 fpu-hard"
BASE_LIB_tune-mips64el = "lib64"
MIPSPKGSFX_VARIANT_tune-mips64el = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mips64el = "mips64el"

TUNE_FEATURES_tune-mips_nf = "o32 bigendian"
BASE_LIB_tune-mips_nf = "lib"
MIPSPKGSFX_VARIANT_tune-mips_nf = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mips_nf = "mips_nf"

TUNE_FEATURES_tune-mips64_nf_n32 = "n32 bigendian"
BASE_LIB_tune-mips64_nf_n32 = "lib32"
MIPSPKGSFX_VARIANT_tune-mips64_nf_n32 = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mips64_nf_n32 = "mips64_nf_n32"

TUNE_FEATURES_tune-mips64_nf = "n64 bigendian"
BASE_LIB_tune-mips64_nf = "lib64"
MIPSPKGSFX_VARIANT_tune-mips64_nf = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mips64_nf = "mips64_nf"

TUNE_FEATURES_tune-mipsel_nf = "o32"
BASE_LIB_tune-mipsel_nf = "lib"
MIPSPKGSFX_VARIANT_tune-mipsel_nf = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mipsel_nf = "mipsel_nf"

TUNE_FEATURES_tune-mips64el_nf_n32 = "n32"
BASE_LIB_tune-mips64el_nf_n32 = "lib32"
MIPSPKGSFX_VARIANT_tune-mips64el_nf_n32 = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mips64el_nf_n32 = "mips64el_nf_n32"

TUNE_FEATURES_tune-mips64el_nf = "n64"
BASE_LIB_tune-mips64el_nf = "lib64"
MIPSPKGSFX_VARIANT_tune-mips64el_nf = "${TUNE_ARCH}"
PACKAGE_EXTRA_ARCHS_tune-mips64el_nf = "mips64el_nf"
