DEFAULTTUNE ?= "aarch64be"

ARMPKGARCH ?= "aarch64be"

TUNEVALID[aarch64be] = "Enable instructions for aarch64"
TUNECONFLICTS[aarch64be] = ""
MACHINEOVERRIDES .= "${@bb.utils.contains("TUNE_FEATURES", "aarch64be", ":aarch64", "" ,d)}"

# Endian base configs
AVAILTUNES += "aarch64be aarch64be_32"
TUNE_FEATURES_tune-aarch64be ?= "aarch64be"
TUNE_FEATURES_tune-aarch64be_32 ?= "aarch64be n32"

TUNE_ARCH = "aarch64be${@bb.utils.contains("TUNE_FEATURES", "n32" , "_32", "", d)}"
TUNE_PKGARCH = "aarch64be${@bb.utils.contains("TUNE_FEATURES", "n32" , "_32", "", d)}"

PACKAGE_EXTRA_ARCHS_tune-aarch64be_32 = "aarch64be_32"

TUNEVALID[n32] = "AARCH64 ilp32 mode"
TUNECONFICTS[n32] = ""

TUNE_CCARGS += "${@bb.utils.contains("TUNE_FEATURES", "n32", " -mabi=ilp32 ", "", d)}"

AARCH_SYS="aarch64${TARGET_VENDOR}${@['-' + d.getVar('TARGET_OS', True), ''][d.getVar('TARGET_OS', True) == ('' or   'custom')]}"
HOST_SYS = "${@[d.getVar('AARCH_SYS'),d.expand('${HOST_ARCH}${HOST_VENDOR}-${HOST_OS}')][bb.data.inherits_class('native', d) or bb.data.inherits_class('nativesdk', d) or  bb.data.inherits_class('crosssdk', d)]}"
TARGET_SYS = "${@[[d.getVar('AARCH_SYS'),d.expand('${HOST_ARCH}${HOST_VENDOR}-${HOST_OS}')][bb.data.inherits_class('native', d) or bb.data.inherits_class('nativesdk', d)], d.expand('${SDK_ARCH}${SDK_VENDOR}-${SDK_OS}')][bb.data.inherits_class('crosssdk', d)]}"
TARGET_ARCH= "${TUNE_PKGARCH}"

