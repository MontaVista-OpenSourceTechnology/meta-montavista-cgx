SRC_URI = "https://archive.mozilla.org/pub/js/${BPN}${PV}.tar.gz \
           file://0001-mozjs17.0.0-fix-the-compile-bug-of-powerpc.patch \
           file://0001-js.pc.in-do-not-include-RequiredDefines.h-for-depend.patch \
           file://0002-Move-JS_BYTES_PER_WORD-out-of-config.h.patch;patchdir=../../ \
           file://0003-Add-AArch64-support.patch;patchdir=../../ \
           file://0004-mozbug746112-no-decommit-on-large-pages.patch;patchdir=../../ \
           file://0005-aarch64-64k-page.patch;patchdir=../../ \
           file://0001-regenerate-configure.patch;patchdir=../../ \
           file://fix-the-compile-error-of-powerpc64.patch;patchdir=../../ \
           file://fix_milestone_compile_issue.patch \
           file://0010-fix-cross-compilation-on-i586-targets.patch;patchdir=../../ \
           file://Manually_mmap_heap_memory_esr17.patch;patchdir=../../ \
           file://0001-compare-the-first-character-of-string-to-be-null-or-.patch;patchdir=../../ \
           "
inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "${bindir}/js17-config"
