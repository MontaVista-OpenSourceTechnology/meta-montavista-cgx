FEATURE_PACKAGES_tools-devrocket = "${FEATURE_PACKAGES_tools-debug} ${FEATURE_PACKAGES_eclipse-debug} ${FEATURE_PACKAGES_tools-profile} packagegroup-devrocket"
FEATURE_PACKAGES_mvl = "distro-version mvl-support"
BBCLASSEXTEND:pn-xz = "native nativesdk"
BBCLASSEXTEND:pn-xz-nativesdk = "native nativesdk"
BBCLASSEXTEND:pn-acl = "native nativesdk"
BBCLASSEXTEND:pn-acl-nativesdk = "native nativesdk"
BBCLASSEXTEND:pn-attr = "native nativesdk"
BBCLASSEXTEND:pn-attr-nativesdk = "native nativesdk"


#From meta-measured, make sure BB_NO_NETWORK continues to work.
SRCREV:pn-pcr-calc = "250141b0cc42e87e83f510fd6a36f68b7b58fe1c"
SRCREV:pn-pcr-calc-native = "250141b0cc42e87e83f510fd6a36f68b7b58fe1c"
SRCREV:pn-pyelftools = "546e692243895888cb2a6201b3bc263fd2cbc1ad"
SRCREV:pn-pyelftools-native = "546e692243895888cb2a6201b3bc263fd2cbc1ad"
LIC_FILES_CHKSUM:pn-pyelftools = "file://LICENSE;md5=5ce2a2b07fca326bc7c146d10105ccfc"
LIC_FILES_CHKSUM:pn-pyelftools-native = "file://LICENSE;md5=5ce2a2b07fca326bc7c146d10105ccfc"

RDEPENDS:packagegroup-tpm:remove = "kernel-module-tpm-nsc"
RDEPENDS:packagegroup-tpm:remove = "kernel-module-tpm-atmel"
RDEPENDS:packagegroup-tpm:remove = "kernel-module-tpm-infineon"

# Meta measured bbappend breaks strongswan package config
MEASURED_STRONGSWAN = " \
    aikgen \
    imc-test \
    imv-test \
    imc-scanner \
    imv-scanner \
    imc-os \
    imv-os \
    imc-attestation \
    imv-attestation \
    imc-swid \
    tnc-ifmap \
    tnc-imc \
    tnc-imv \
    tnc-pdp \
    tnccs-11 \
    tnccs-20 \
    tnccs-dynamic \
    tss-trousers \
"
PACKAGECONFIG:pn-strongswan = "charon curl gmp openssl stroke sqlite3 \
                               ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd-charon', '', d)} \
                               ${@bb.utils.contains('DISTRO_FEATURES', 'ldap', 'ldap', '', d)} \
                               ${@bb.utils.contains("BBFILE_COLLECTIONS", "measured", "${MEASURED_STRONGSWAN}", "", d)} \
"

PACKAGECONFIG:append:pn-gdb = " python "

CFLAGS:pn-cacao-initial-native:append = " -fno-strict-aliasing "
CFLAGS:pn-efivar-native:append = " -fno-strict-aliasing "

PREFERRED_VERSION_python-sqlalchemy = "1.0.8"
PREFERRED_VERSION_python-greenlet = "0.4.9"

PREFERRED_RPROVIDER_lib32-initd-functions = "lib32-initscripts"
PREFERRED_RPROVIDER_lib64-initd-functions = "lib64-initscripts"
OS_DEFAULT_INITSCRIPT_PARAMS ??= "defaults 30 10"

PREFERRED_RPROVIDER_u-boot-mkimage ?= "u-boot-mkimage"
PREFERRED_RPROVIDER_lib32-u-boot-mkimage ?= "lib32-u-boot-mkimage"
PREFERRED_RPROVIDER_lib64-u-boot-mkimage ?= "lib64-u-boot-mkimage"

# Get rid of older bbappend files
BBMASK += "meta-openstack/recipes-connectivity/openssh/openssh_6.%.bbappend"
BBMASK += "meta-openstack/recipes-support/iproute2/iproute2_3.%.bbappend"
BBMASK += "meta-openstack/recipes-support/fuse/fuse_2.9.3.bbappend"
BBMASK += "meta-openstack/recipes-extended/iscsi-initiator-utils/"
BBMASK += "meta-openstack/recipes-support/postgresql/"
BBMASK += "meta-cgl-common/recipes-cgl/makedumpfile/makedumpfile_1.5.8.bb"
BBMASK += "meta-virtualization/recipes-devtools/python/python3-twisted_13.2.0.bb"

LLVMVERSION = "13.0.1"
