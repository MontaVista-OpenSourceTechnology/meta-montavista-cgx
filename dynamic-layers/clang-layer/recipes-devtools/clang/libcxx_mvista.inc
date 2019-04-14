LIBEXT="${@d.getVar("base_libdir").replace("/lib","")}"
EXTRA_OECMAKE_prepend_class-target = "\
                                     -DLLVM_LIBDIR_SUFFIX=${LIBEXT} \
                                     -DLIBCXX_CXX_ABI_LIBRARY_PATH=${B}/lib${LIBEXT} \
"
EXTRA_OECMAKE_remove_class-target = "-DLIBCXX_CXX_ABI_LIBRARY_PATH=${B}/lib "
LDFLAGS_class-target .= " -L${B}/lib${LIBEXT} "


PROVIDES_remove_powerpc = "libunwind"
PROVIDES_remove_powerpc64 = "libunwind"

USE_LLVM_UNWINDER_powerpc = "OFF"
USE_LLVM_UNWINDER_powerpc64 = "OFF"

COMPILE_TARGETS_powerpc = "cxxabi"
COMPILE_TARGETS_powerpc64 = "cxxabi"

INSTALL_TARGETS_powerpc = "install-cxxabi"
INSTALL_TARGETS_powerpc64 = "install-cxxabi"

PACKAGES_remove_powerpc = "libunwind"
PACKAGES_remove_powerpc64 = "libunwind"

PROVIDES_remove_aarchilp32 = "libunwind"
PROVIDES_remove_armv6 = "libunwind"

