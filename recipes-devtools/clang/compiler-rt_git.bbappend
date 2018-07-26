do_install_append () {
        install -d ${D}${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/lib/linux
        if [ "${exec_prefix}/lib" != ${libdir} -a -d ${D}${exec_prefix}/lib/linux ]; then
                for f in `find ${D}${exec_prefix}/lib/linux -maxdepth 1 -type f`
                do
                        mv $f ${D}${libdir}/clang/${MAJOR_VER}.${MINOR_VER}.${PATCH_VER}/lib/linux
                done
                 cp -a ${D}${exec_prefix}/lib/* ${D}${libdir}/
                rmdir ${D}${exec_prefix}/lib/linux
        fi
}
