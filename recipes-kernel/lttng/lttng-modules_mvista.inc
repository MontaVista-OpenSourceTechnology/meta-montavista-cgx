PR .= ".2"

DEPENDS += "elfutils-native"
FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"
# FIXME 0001-Fix-update-timer-instrumentation-on-4.16-and-4.14-rt.patch no longer applies
SRC_URI += "file://0001-Fix-update-timer-instrumentation-on-4.16-and-4.14-rt.patch;apply=no \
            file://fix-unknown-symbol-__migrate_disabled-with-CONFIG_PREEMPT_RT_FULL.patch"

EXTRA_OEMAKE += "KDIR='${STAGING_KERNEL_DIR}' HOSTCC='gcc -I${STAGING_INCDIR_NATIVE} \
                 -L${STAGING_DIR_NATIVE}/usr/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/usr/lib \
                 -L${STAGING_DIR_NATIVE}/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/lib'"

do_compile_prepend () {
        export SKIP_STACK_VALIDATION=1
}
