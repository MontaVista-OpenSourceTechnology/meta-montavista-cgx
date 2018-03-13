PR .= ".1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"
SRC_URI += "file://0001-Fix-update-timer-instrumentation-on-4.16-and-4.14-rt.patch"

EXTRA_OEMAKE += "KDIR='${STAGING_KERNEL_DIR}' HOSTCC='gcc -I${STAGING_INCDIR_NATIVE} \
                 -L${STAGING_DIR_NATIVE}/usr/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/usr/lib \
                 -L${STAGING_DIR_NATIVE}/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/lib'"

do_compile_prepend () {
        export SKIP_STACK_VALIDATION=1
}
