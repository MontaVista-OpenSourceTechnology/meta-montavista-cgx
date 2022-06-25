PR .= ".4"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"
SRC_URI += "file://0001-Fix-update-timer-instrumentation-on-4.16-and-4.14-rt.patch \
            file://fix-unknown-symbol-__migrate_disabled-with-CONFIG_PREEMPT_RT_FULL.patch \
            file://0001-lttng-module-Compilation-Fix.patch \
            file://0017-fix-random-remove-unused-tracepoints-v5.18.patch \
            file://0018-fix-random-remove-unused-tracepoints-v5.10-v5.15.patch \
            file://0019-fix-random-tracepoints-removed-in-stable-kernels.patch \
            "

EXTRA_OEMAKE += "KDIR='${STAGING_KERNEL_DIR}' HOSTCC='gcc -I${STAGING_INCDIR_NATIVE} \
                 -L${STAGING_DIR_NATIVE}/usr/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/usr/lib \
                 -L${STAGING_DIR_NATIVE}/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/lib'"

do_compile_prepend () {
        export SKIP_STACK_VALIDATION=1
}
