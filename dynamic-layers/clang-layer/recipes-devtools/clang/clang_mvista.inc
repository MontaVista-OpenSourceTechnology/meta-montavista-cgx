LIBEXT = "${@d.getVar("base_libdir").replace("/lib","")}"
EXTRA_OECMAKE:prepend:class-target = "\
                                     -DLLVM_LIBDIR_SUFFIX=${LIBEXT} \
"
QAPATHTEST[dev-so] = ""
