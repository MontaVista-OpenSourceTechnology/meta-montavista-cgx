PR .= ".3"

DEPENDS += "elfutils-native"

EXTRA_OEMAKE += "KDIR='${STAGING_KERNEL_DIR}' HOSTCC='gcc -I${STAGING_INCDIR_NATIVE} \
                 -L${STAGING_DIR_NATIVE}/usr/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/usr/lib \
                 -L${STAGING_DIR_NATIVE}/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/lib'"

do_compile:prepend () {
        export SKIP_STACK_VALIDATION=1
}
