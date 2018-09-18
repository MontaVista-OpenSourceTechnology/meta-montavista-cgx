LIBEXT="${@d.getVar("base_libdir").replace("/lib","")}"
EXTRA_OECMAKE_prepend_class-target = "\
                                     -DLLVM_LIBDIR_SUFFIX=${LIBEXT} \
                                     -DLIBCXX_CXX_ABI_LIBRARY_PATH=${B}/lib${LIBEXT} \
"
EXTRA_OECMAKE_remove = "@{oe.utils.conditional(d.getVar("base_libdir"), '/lib', '', '-DLIBCXX_CXX_ABI_LIBRARY_PATH=${B}/lib')} "
