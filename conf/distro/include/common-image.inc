FEATURE_PACKAGES_tools-devrocket = "${FEATURE_PACKAGES_tools-debug} ${FEATURE_PACKAGES_eclipse-debug} ${FEATURE_PACKAGES_tools-profile} packagegroup-devrocket"
FEATURE_PACKAGES_mvl = "distro-version mvl-support"
BBCLASSEXTEND_pn-xz = "native nativesdk"
BBCLASSEXTEND_pn-xz-nativesdk = "native nativesdk"
BBCLASSEXTEND_pn-acl = "native nativesdk"
BBCLASSEXTEND_pn-acl-nativesdk = "native nativesdk"
BBCLASSEXTEND_pn-attr = "native nativesdk"
BBCLASSEXTEND_pn-attr-nativesdk = "native nativesdk"


#From meta-measured, make sure BB_NO_NETWORK continues to work.
SRCREV_pn-tpm2.0-tss = "557c87357882683d4842d7a7d5009fd077136817"
SRCREV_pn-pcr-calc = "250141b0cc42e87e83f510fd6a36f68b7b58fe1c"
SRCREV_pn-pcr-calc-native = "250141b0cc42e87e83f510fd6a36f68b7b58fe1c"
SRCREV_pn-pyelftools = "546e692243895888cb2a6201b3bc263fd2cbc1ad"
SRCREV_pn-pyelftools-native = "546e692243895888cb2a6201b3bc263fd2cbc1ad"
LIC_FILES_CHKSUM_pn-pyelftools = "file://LICENSE;md5=5ce2a2b07fca326bc7c146d10105ccfc"
LIC_FILES_CHKSUM_pn-pyelftools-native = "file://LICENSE;md5=5ce2a2b07fca326bc7c146d10105ccfc"

RDEPENDS_packagegroup-tpm_remove = "kernel-module-tpm-nsc"
RDEPENDS_packagegroup-tpm_remove = "kernel-module-tpm-atmel"
RDEPENDS_packagegroup-tpm_remove = "kernel-module-tpm-infineon"

# Fix for meta-security
EXTRA_OEMAKE_pn-nmap_append = "PYTHON=/usr/bin/python"

CFLAGS_pn-cacao-initial-native_append = " -fno-strict-aliasing "
