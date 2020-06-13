LIBEXT="${@d.getVar("base_libdir").replace("/lib","")}"
EXTRA_OECMAKE_prepend_class-target = "\
                                     -DLLVM_LIBDIR_SUFFIX=${LIBEXT} \
"
QAPATHTEST[dev-so] = ""
