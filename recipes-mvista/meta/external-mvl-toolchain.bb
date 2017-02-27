require recipes-core/glibc/glibc-package.inc

require external-mvl-toolchain.inc

DEPENDS="external-mvl-toolchain-cross-${TARGET_ARCH}"
ERROR_QA_remove = "instalned-vs-shipped"
ERROR_QA_remove = "dev-deps"
ERROR_QA_remove ="already-stripped"
#Even after chowning all files some still are locally owned, however when
#put in rpms the owner is converted to root.
WARN_QA_remove ="host-user-contaminated"

INHIBIT_DEFAULT_DEPS = "1"

# License applies to this recipe code, not the toolchain itself
LICENSE = "MIT"

TARGET_SYS_aarch64be-32 = "${CSL_TARGET_SYS}"
HOST_SYS_aarch64be-32 = "${CSL_TARGET_SYS}"
TARGET_SYS_aarch64be = "${CSL_TARGET_SYS}"
HOST_SYS_aarch64be = "${CSL_TARGET_SYS}"
INSANE_SKIP_${PN} +="already-stripped"
INSANE_SKIP_linux-libc-headers += "dev-deps"

LIBC_PROVIDES_LIST = " \
     virtual/libc \
     virtual/libintl \
     virtual/libiconv \
     glibc-thread-db \
     glibc-utils \
     glibc \
     glibc-dev \
" 
LIBC_PROVIDES = "${@base_conditional('EXTERNAL_GLIBC', '1', bb.data.expand('${LIBC_PROVIDES_LIST}',d), '' , d)}"
PROVIDES += "\
     virtual/${TARGET_PREFIX}gcc \
     virtual/${TARGET_PREFIX}g++ \
     virtual/${TARGET_PREFIX}gcc-initial \
     virtual/${TARGET_PREFIX}gcc-intermediate \
     virtual/${TARGET_PREFIX}binutils \
     virtual/${TARGET_PREFIX}compilerlibs \
     virtual/${TARGET_PREFIX}libc-initial \
     virtual/${TARGET_PREFIX}libc-for-gcc \
     libgcc \
     libgomp \
     libgomp-dev \
     libc-mtrace\
     glibc-mtrace\
     gdb-cross \
     linux-libc-headers \
     virtual/linux-libc-headers \
     ${LIBC_PROVIDES} \
     gcc-runtime \
"

INSANE_SKIP="1"
INSANE_SKIP_${PN}-dbg="1"
INSANE_SKIP_${PN}="1 installed_vs_shipped"
BINV="${PV}"
PR .= ".1"

#SRC_URI = "http://www.codesourcery.com/public/gnu_toolchain/${CSL_TARGET_SYS}/arm-${PV}-${TARGET_PREFIX}i686-pc-linux-gnu.tar.bz2"
QAPATHTEST[arch]=""
QAPATHTEST[dev-so] = "" 
QAPATHTEST[debug-files] = ""
QAPATHTEST[staticdev] = ""
QAPATHTEST[ldflags] = ""
ALL_QA="ldflags useless-rpaths rpaths staticdev xorg-driver-abi textrel dev-so debug-deps dev-deps debug-files arch la2 pkgconfig la perms dep-cmp pkgvarcheck"
#Ugly workaround.

TOOLCHAIN_APPSA="*-strip,strip,gcov,gcov-dump,ld,*-ld,*-gdb,addr2line,gcc,*-gcc,nm,*-nm,ranlib,*-ranlib,merge-gcda"
TOOLCHAIN_APPSB="*-as,as,*-gcc-ranlib,ld.bfd,*-g++,g++,cc,gcc-ar,gcc-ranlib,cpp,run,c++filt,gdb,*-gdb,*-ar,ar"
TOOLCHAIN_APPSC="objdump,*-objdump,size,strings,gprof,*-gcc-*,elfedit,gcc-nm,objcopy,*-objcopy,c++,*-c++,readelf,*-readelf"
SRC_URI = "file://SUPPORTED \
file://nscd/ \
"
GLIBC_UTILS_DIRS="usr/sbin usr/bin usr/libexec"

GCCHEADERS="float.h,iso646.h,stdalign.h,stdarg.h,stdbool.h,stddef.h,stdfix.h,stdint-gcc.h,stdint.h,stdnoreturn.h,varargs.h"
ARCHGCCHEADERS=""
ARCHGCCHEADERS_aarch64 = "arm_neon.h,arm_neon.h"
ARCHGCCHEADERS_x86-64="*intrin.h,cpuid.h,cross-stdarg.h,mm3dnow.h,mm_malloc.h"
ARCHGCCHEADERS_i686="*intrin.h,cpuid.h,cross-stdarg.h,mm3dnow.h,mm_malloc.h"
ARCHGCCHEADERS_mips="loongson.h,loongson.h"
ARCHGCCHEADERS_mips64="loongson.h,loongson.h"
ARCHGCCHEADERS_armv7a="arm_neon.h,mmintrin.h,unwind-arm-common.h"
ARCHGCCHEADERS_powerpc="altivec.h,paired.h,ppc-asm.h,ppu_intrinsics.h,si2vmx.h,spe.h,spu2vmx.h,vec_types.h"
BINUTILSHEADERS="ansidecl.h,bfd.h,bfdlink.h,dis-asm.h,plugin-api.h,symcat.h"

do_install[vardeps] += "EXTERNAL_GLIBC"

do_install() {
    cp -a ${WORKDIR}/nscd ${S}/
    set -x
    install -d ${D}${sysconfdir} ${D}${bindir} ${D}${sbindir} ${D}${base_bindir} ${D}${libdir}
    install -d ${D}${base_libdir} ${D}${base_sbindir} ${D}${datadir} ${D}/usr ${D}/lib ${D}/usr/lib

    local copybase=${EXTERNAL_TOOLCHAIN}/${CSL_TARGET_SYS}/sys-root
    local copylib=${copybase}
    if [ -d ${copybase}/${CSL_TARGET_CORE} ]; then
        copylib=${copybase}/${CSL_TARGET_CORE}
        if [ ! -e ${copylib}/usr/include ]; then
            cp -a ${copybase}/usr/include ${D}/usr
        fi
    fi
    [ -e ${copylib}/lib ] && cp -a ${copylib}/lib/. ${D}/lib
    [ -e ${copylib}/lib32 ] && cp -a ${copylib}/lib32/. ${D}/lib32
    [ -e ${copylib}/lib32-fp ] && cp -a ${copylib}/lib32-fp/. ${D}/lib32-fp
    [ -e ${copylib}/lib64 ] && cp -a ${copylib}/lib64/.  ${D}/lib64
    [ -e ${copylib}/lib64-fp ] && cp -a ${copylib}/lib64-fp/. ${D}/lib64-fp
    [ -e ${copylib}/libilp32 ] && cp -a ${copylib}/libilp32/. ${D}/libilp32
    cp -a ${copylib}/etc/.  ${D}${sysconfdir}
    [ -e ${copylib}/sbin${BASELIB_SUFFIX} ] && cp -a ${copylib}/sbin${BASELIB_SUFFIX}/. ${D}${base_sbindir}
    cp -a ${copylib}/usr/. ${D}/usr/
# FixME: c++
    mkdir -p ${D}${libdir}/gcc/${TARGET_SYS}
#    mkdir -p ${D}${includedir}/c++
#    cp -a ${EXTERNAL_TOOLCHAIN}/${CSL_TARGET_SYS}/include/c++/*/* ${D}${includedir}/c++/
    if ls ${EXTERNAL_TOOLCHAIN}/${CSL_TARGET_SYS}/${base_libdir}/*.la; then
       cp -a ${EXTERNAL_TOOLCHAIN}/${CSL_TARGET_SYS}/${base_libdir}/*.la ${D}${base_libdir}
    fi
# FixMe: c++
#    if [ "${CSL_TARGET_SYS}" != "${TARGET_SYS}" ] ; then
#       ln -s ${CSL_TARGET_SYS} ${D}${includedir}/c++/${TARGET_SYS}
#    fi
#    cp -a ${EXTERNAL_TOOLCHAIN}/lib/gcc/${CSL_TARGET_SYS}/* ${D}/${libdir}/gcc/${TARGET_SYS}/
    # Fix conflicts with target gcc.
    rm -rf ${D}/${libdir}/gcc/${TARGET_SYS}/*/plugin
    rm -rf ${D}/${libdir}/gcc/${TARGET_SYS}/*/include-fixed
    rm -rf ${D}/${libdir}/gcc/${TARGET_SYS}/*/include/{${GCCHEADERS}}
    rm -rf ${D}/${libdir}/gcc/${TARGET_SYS}/*/include/{${ARCHGCCHEADERS}}
    # Fix conflicts with target binutils
    rm -rf ${D}/${includedir}/{${BINUTILSHEADERS}}
    # Fix conflicts with ncurses
    rm -rf ${D}/${includedir}/termcap.h
    # Fix conflicts with linux-firmware
    rm -rf ${D}/lib/firmware
    # Fix conflicts with gdb
    rm -rf ${D}/${datadir}/gdb

    if [ -e ${copybase}/sbin${ALTBINDIR_SUFFIX}${BASELIB_SUFFIX} ] ; then 
        rm ${D}${base_sbindir}/ -rf
        cp -a ${copybase}/sbin${ALTBINDIR_SUFFIX}${BASELIB_SUFFIX}/. ${D}${base_sbindir}/
    fi
    if [ "x${ALTBINDIR_SUFFIX}" != "x" -a -d ${D}/usr/bin${ALTBINDIR_SUFFIX}${BASELIB_SUFFIX} ] ; then
        for dir in ${GLIBC_UTILS_DIRS} ; do
            [ -e ${D}/$dir ] && mv ${D}/$dir ${D}/$dir.base
            if [ -e "${D}/$dir$(echo ${ALTBINDIR_SUFFIX}${BASELIB_SUFFIX})" ] ; then
             mv ${D}/$dir$(echo ${ALTBINDIR_SUFFIX}${BASELIB_SUFFIX}) ${D}/$dir
            fi
        done
    fi
    rm  -f ${D}/${libdir}/libstdc++.so
    ln -s libstdc++.so.6 ${D}/${libdir}/libstdc++.so

     rm -f ${D}/usr/bin/{${TOOLCHAIN_APPSA}}
     rm -f ${D}/usr/bin/{${TOOLCHAIN_APPSB}}
     rm -f ${D}/usr/bin/{${TOOLCHAIN_APPSC}}
     rm -f ${D}/usr/bin/lddlibc4
     rm -rf ${D}/usr/libexec/gcc
     if [ -e ${D}${prefix}/info ]; then
          mv ${D}${prefix}/info ${D}${infodir}
     fi
     if [ -e ${D}${prefix}/man ]; then
          mv ${D}${prefix}/man ${D}${mandir}
     fi

     rm -f ${D}${sysconfdir}/rpc
     rm -fr ${D}${datadir}/zoneinfo
     if [ -e ${D}${includedir}/mtd/ubi-user.h ] ; then
        sed -i -e 's/__packed/__attribute__ ((packed))/' ${D}${includedir}/mtd/ubi-user.h
     fi
     sed -i -e "s# /lib# ../../lib#g" -e "s# /usr/lib# ../../usr/lib#g" ${D}${libdir}/libc.so
     [ -e "${D}/usr/lib/libc.so" ] && sed -i -e "s# /lib# ../../lib#g" -e "s# /usr/lib# ../../usr/lib#g" ${D}/usr/lib/libc.so
     sed -i -e "s# /lib# ../../lib#g" -e "s# /usr/lib# ../../usr/lib#g" ${D}${libdir}/libpthread.so
     [ -e "${D}/usr/lib/libpthread.so" ] && sed -i -e "s# /lib# ../../lib#g" -e "s# /usr/lib# ../../usr/lib#g" ${D}/usr/lib/libpthread.so
     # Don't include broken symbolic links
     chmod 755 `find -L ${D}/lib*/ld*.so* -not -type l`
#     localeinclude="$(ls -d ${D}/${includedir}/glibc-locale-internal-* | head -n 1)"
#     if [ "$localeinclude" != "${D}/${includedir}/glibc-locale-internal-${MULTIMACH_TARGET_SYS}" ] ; then
#           rm -rf ${D}/${includedir}/glibc-locale-internal-${MULTIMACH_TARGET_SYS}
#           mv $localeinclude ${D}/${includedir}/glibc-locale-internal-${MULTIMACH_TARGET_SYS}
#     fi 

# Clean up alternate abi lib directories.
     for each in ${D}/lib*; do
         if [ "x$each" != "x${D}${base_libdir}" ] ; then
               rm -rf $each
         fi
     done
     for each in ${D}/usr/lib*; do
         if [ "x$each" != "x${D}${libdir}" ] ; then
               rm -rf $each
         fi
     done
     if [ "${TARGET_VENDOR_MULTILIB_ORIGINAL}" != "" -a "${TARGET_VENDOR}" != "${TARGET_VENDOR_MULTILIB_ORIGINAL}" ]; then
       for each in ${D}/${includedir}/glibc-locale-internal-*; do 
         if [ "x$each" != "x${D}/${includedir}/glibc-locale-internal-${MULTIMACH_TARGET_SYS}" ] ; then
               rm -rf $each
         fi
       done
     else
         rm -rf ${D}/${includedir}/glibc-locale-internal-*mllib*
         localeinclude="$(ls -d ${D}/${includedir}/glibc-locale-internal-* | head -n 1)"
         if [ "$localeinclude" != "${D}/${includedir}/glibc-locale-internal-${MULTIMACH_TARGET_SYS}" ] ; then
            rm -rf ${D}/${includedir}/glibc-locale-internal-${MULTIMACH_TARGET_SYS}
            mv $localeinclude ${D}/${includedir}/glibc-locale-internal-${MULTIMACH_TARGET_SYS}
         fi
     fi
     for each in ${D}/usr/bin*; do
         if [ "x$each" != "x${D}${bindir}" ] ; then
               rm -rf $each
         fi
     done
     for each in ${D}/usr/sbin*; do
         if [ "x$each" != "x${D}${sbindir}" ] ; then
               rm -rf $each
         fi
     done

     install -d ${D}/usr/lib
     touch ${D}/usr/lib/.empty
     GCCDIR="$(echo ${D}${libdir}/*ml*/6.*)"
     if [ "${PACKAGE_ARCH}" == "i586" ] ; then
             if [ -n "${MULTILIB_VARIANTS}" ] ; then
                install -d ${D}/usr/lib64
                touch ${D}/usr/lib64/.empty
                ln -s . $GCCDIR/32
                ln -s $(basename $(dirname $GCCDIR)) ${D}${libdir}/${TARGET_SYS_MULTILIB_ORIGINAL}
             fi
     fi


}
glibc_package_preprocess_append () {
    mkdir -p ${PKGD}${exec_prefix}/lib
    touch ${PKGD}${exec_prefix}/lib/.empty
    if [ "${PACKAGE_ARCH}" == "i586" ] ; then
             if [ -n "${MULTILIB_VARIANTS}" ] ; then
                touch ${D}/usr/lib64/.empty
             fi
    fi
}

oe_multilib_header () {
:
}

sysroot_stage_all_append () {
       install -d  ${SYSROOT_DESTDIR}/usr/lib
       if [ "${PACKAGE_ARCH}" == "i586" ] ; then
                install -d ${SYSROOT_DESTDIR}/usr/lib64/
                touch ${SYSROOT_DESTDIR}/usr/lib64/.empty
       fi
}

#tmp hack
do_install_mips64-nf-n32_append () {
}

LIBC_PACKAGES_LIST =  "linux-libc-headers linux-libc-headers-dev linux-libc-headers-dbg"
LIBC_PACKAGES_LIST += "ldd ${PN}-dev ${PN}-staticdev ${PN}-doc ${PN}-pcprofile ${PN}-gconv" 
LIBC_PACKAGES_LIST += "${PN}-dbg catchsegv sln nscd ${PN}-utils"
LIBC_PACKAGES_LIST += "${PN}-pic libcidn libmemusage libsegfault libsotruss glibc-thread-db ${PN} glibc-extra-nss"

LIBC_PACKAGES="${@base_conditional('EXTERNAL_GLIBC', '1', bb.data.expand('${LIBC_PACKAGES_LIST}',d), 'external-mvl-toolchain' , d)}"
PACKAGES = "libitm libitm-dev libitm-staticdev gcc-sanitizers libgo libgo-dev libgo-staticdev libgcc libgcc-dev libssp libssp-dev libssp-staticdev \
          libgomp libgomp-dev libgomp-staticdev libmudflap libmudflap-dev libmudflap-staticdev  \
          libstdc++ libstdc++-dev libstdc++-staticdev libatomic libatomic-dev libatomic-staticdev libgcov-dev \
          libgfortran libstdc++-precompile-dev libg2c libg2c-dev libgfortran-dev libtsan libtsan-dev \
          libtsan-staticdev libasan libasan-dev libasan-staticdev \
          liblsan liblsan-dev liblsan-staticdev ${LIBC_PACKAGES} \
	  libquadmath libquadmath-dev libquadmath-staticdev libubsan libubsan-dev" 

do_install_locale_prepend () {
     if [ "x${ALTBINDIR_SUFFIX}" != "x" ] ; then
            altbindir="${bindir}$(echo ${ALTBINDIR_SUFFIX})" 
     else
            altbindir="${bindir}" 
     fi  
        if [ -e ${D}$altbindir/localedef ]; then
                mv -f ${D}$altbindir/localedef ${dest}$altbindir
        fi
}

INSANE_SKIP_libgcc = "1"
INSANE_SKIP_libstdc++ = "1"
INSANE_SKIP_gdbserver = "1"

PKG_${PN} = "${@base_conditional('EXTERNAL_GLIBC', '1', 'glibc', 'external-mvl-toolchain' , d)}"
PKG_${PN}-dev = "glibc-dev"
PKG_${PN}-staticdev = "glibc-staticdev"
PKG_${PN}-doc = "glibc-doc"
PKG_${PN}-dbg = "glibc-dbg"
PKG_${PN}-pic = "glibc-pic"
PKG_${PN}-utils = "glibc-utils"
PKG_${PN}-gconv = "glibc-gconv"
PKG_${PN}-extra-nss = "glibc-extra-nss"
PKG_${PN}-thread-db = "glibc-thread-db"
PKG_${PN}-pcprofile = "glibc-pcprofile"

PKGV = "${CSL_VER_LIBC}"
PKGV_linux-libc-headers = "${CSL_VER_KERNEL}"
PKGV_linux-libc-headers-dev = "${CSL_VER_KERNEL}"
PKGV_libgcc = "${CSL_VER_GCC}"
PKGV_libgcc-dev = "${CSL_VER_GCC}"
PKGV_libstdc++ = "${CSL_VER_GCC}"
PKGV_libstdc++-dev = "${CSL_VER_GCC}"
PKGV_gdbserver = "${CSL_VER_GDB}"
PKGV_gdbserver-dbg = "${CSL_VER_GDB}"
EXTRALIBDIR = "${@base_conditional('PACKAGE_ARCH', 'mips64', '/lib64', '', d)}"
GLIBC_FILE_LIST="/lib/ld-* ${libc_baselibs} ${EXTRALIBDIR} ${libexecdir}/* ${@base_conditional('USE_LDCONFIG', '1', '${base_sbindir}/ldconfig ${sysconfdir}/ld.so.conf', '', d)}"
FILES_${PN} = "${@base_conditional('EXTERNAL_GLIBC', '1', bb.data.expand('${GLIBC_FILE_LIST}',d) , '' , d)}' /usr/lib*/.empty"
RDEPENDS_${PN}-dev += "linux-libc-headers libgcc-dev"
RPROVIDES_${PN} += "glibc-pcprofile glibc-pcprofile glibc-pic glibc-pic glibc libc-mtrace glibc-mtrace glibc"
RPROVIDES_${PN}-dbg += "glibc-dbg glibc-dbg"
RPROVIDES_${PN}-utils += "glibc-utils glibc-utils"
RPROVIDES_${PN}-dev += "glibc-dev glibc-dev virtial-libc-dev libc-dev libc6-dev"
RPROVIDES_${PN}-doc += "glibc-doc glibc-doc"
RPROVIDES_${PN}-extra-nss += "glibc-extra-nss glibc-extra-nss"
RPROVIDES_${PN}-thread-db += "glibc-thread-db glibc-thread-db"
RDEPENDS_glibc-dbg += "${PN}-dbg glibc-dbg"
RDEPENDS_glibc-staticdev += "${PN}-staticdev glibc-staticdev"
RDEPENDS_linux-libc-headers += "linux-libc-headers-dev"
RDEPENDS_nscd += "bash"
ALLOW_EMPTY_external-mvl-toolchain = "1"
#ALLOW_EMPTY_glibc-dbg = "1"
ALLOW_EMPTY_linux-libc-headers = "1"
FILES_${PN}-utils += "${base_bindir}"

FILES_libgcc = "${base_libdir}/libgcc_s.so.1 ${libdir}/libgcc_s.so.1"
FILES_libgcc-dev = "${base_libdir}/libgcc_s.so ${libdir}/libgcc_s.so ${libdir}/gcc/* ${libdir}/${TARGET_SYS}"
FILES_libstdc++ = "${base_libdir}/libstdc++.so.* ${base_libdir}/libstdc++.so.* ${libdir}/libstdc++.so.* ${libdir}/libstdc++.so.*"
FILES_libstdc++-dev = "${includedir}/c++ \
    ${base_libdir}/libstdc++.so \
    ${libdir}/libstdc++.so \
    ${libdir}/libstdc++.la \
    ${libdir}/libstdc++.a \
    ${libdir}/libsupc++.la \
    ${libdir}/libsupc++.a"
FILES_linux-libc-headers-dev = "${includedir}/asm* \
    ${includedir}/linux \
    ${includedir}/mtd \
    ${includedir}/rdma \
    ${includedir}/scsi \
    ${includedir}/sound \
    ${includedir}/video \
"
FILES_gdbserver = "${bindir}/gdbserver ${libdir}/bin/sysroot-gdbserver"
FILES_gdbserver-dbg = "${bindir}/.debug/gdbserver"

FILES_${PN} += "/etc/ld.so.conf"
# include python debugging scripts
FILES_${PN}-dbg += "\
    ${libdir}/libstdc++.so.*-gdb.py \
    ${datadir}/gcc-*/python/libstdcxx \
"
#GCC sanitizers
RDEPENDS_libasan += "libstdc++"
RDEPENDS_libubsan += "libstdc++"
RDEPENDS_liblsan += "libstdc++"
RDEPENDS_libtsan += "libstdc++"
RDEPENDS_libasan-dev += "gcc-sanitizers"
RDEPENDS_libubsan-dev += "gcc-sanitizers"
RDEPENDS_liblsan-dev += "gcc-sanitizers"
RDEPENDS_libtsan-dev += "gcc-sanitizers"
RRECOMMENDS_gcc-sanitizers += "libasan libubsan"
RRECOMMENDS_gcc-sanitizers_append_x86-64 = " liblsan libtsan"
RRECOMMENDS_gcc-sanitizers_append_x86 = " liblsan"

FILES_gcc-sanitizers = "${libdir}/libsanitizer.spec ${libdir}/gcc/${TARGET_SYS}/${BINV}/include/sanitizer/*.h"

FILES_liblsan += "${libdir}/liblsan.so.* ${libdir}/sanitizer.spec"
FILES_liblsan-dbg += "${libdir}/.debug/liblsan.so.*"
FILES_liblsan-dev += "\
    ${libdir}/liblsan.so \
    ${libdir}/liblsan.la \
"
FILES_liblsan-staticdev += "${libdir}/liblsan.a"

FILES_libssp = "${base_libdir}/libssp.so.* ${libdir}/libssp.so.*"
FILES_libssp-dev = " \
  ${base_libdir}/libssp*.so \
  ${libdir}/libssp*.so \
  ${libdir}/libssp*_nonshared.a \
  ${libdir}/libssp*.la \
  ${libdir}/gcc/${TARGET_SYS}/${BINV}/include/ssp"
FILES_libssp-staticdev = " \
  ${libdir}/libssp*.a"

FILES_libmudflap = "${libdir}/libmudflap*.so.*"
FILES_libmudflap-dev = "\
  ${libdir}/libmudflap*.so \
  ${libdir}/libmudflap*.a \
  ${libdir}/libmudflap*.la"

FILES_libasan = "${libdir}/libubsan*${SOLIBS} ${libdir}/libasan*${SOLIBS}"
FILES_libasan-dev = "${libdir}/libubsan*${SOLIBSDEV} ${libdir}/libasan*${SOLIBSDEV}"
FILES_libasan-staticdev = "${libdir}/libubsan*.a ${libdir}/libasan*.a"

FILES_libtsan += "${libdir}/libtsan.so.*"
FILES_libtsan-dbg += "${libdir}/.debug/libtsan.so.*"
FILES_libtsan-dev += "\
    ${libdir}/libtsan.so \
    ${libdir}/libtsan.la \
"
FILES_libtsan-staticdev += "${libdir}/libtsan.a"


FILES_libgomp = "${libdir}/libgomp*${SOLIBS}"
FILES_libgomp-dev = "\
  ${libdir}/libgomp*${SOLIBSDEV} \
  ${libdir}/libgomp*.la \
  ${libdir}/libgomp.spec \
  ${libdir}/gcc/${TARGET_SYS}/${BINV}/include/omp.h \
  "
FILES_libgomp-staticdev = "\
  ${libdir}/libgomp*.a \
  "
FILES_libatomic = "${libdir}/libatomic.so.*"
FILES_libatomic-dev = "\
    ${libdir}/libatomic.so \
    ${libdir}/libatomic.la \
"
FILES_libatomic-staticdev = "${libdir}/libatomic.a"

FILES_libgcov-dev = "\
    ${libdir}/${TARGET_SYS}/${BINV}/libgcov.a \
"

FILES_libgo = "\
     ${libdir}/libgo.so.* \
"

FILES_libgo-dev = "\
     ${libdir}/libgo.so \
     ${libdir}/libgo.la \
     ${libdir}/go \
"
FILES_libgo-staticdev = "\
     ${libdir}/libgo.a \
     ${libdir}/libnetgo.a \
     ${libdir}/libgolibbegin.a \
     ${libdir}/libgobegin.a \
"
FILES_libitm = "${libdir}/libitm.so.*"
SUMMARY_libitm = "GNU transactional memory support library"
FILES_libitm-dev = "\
    ${libdir}/libitm.so \
    ${libdir}/libitm.la \
    ${libdir}/libitm.spec \
"
SUMMARY_libitm-dev = "GNU transactional memory support library - development files"
FILES_libitm-staticdev = "${libdir}/libitm.a"
SUMMARY_libitm-staticdev = "GNU transactional memory support library - static development files"

#FIXME this shouldn't be empty
ALLOW_EMPTY_libgcov-dev = "1"
CSL_VER_GDB  = "7.9.1" 
CSL_VER_MAIN = "6.2.0"
CSL_VER_LIBC = "2.22"

def get_mlprovides(provide,d) :
    mlvariants = d.getVar("MULTILIB_VARIANTS",True)
    rprovides = ""
    for each in mlvariants.split():
       rprovides = "%s %s-%s" % (rprovides, each, provide)
    return rprovides

RPROVIDES_libgcc += "${@['','base-libgcc'][d.getVar('MLPREFIX', True) == '']}"

RDEPENDS_libgcc-dev += "${@['','base-libgcc-dev'][d.getVar('MLPREFIX', True) != '']}"
RDEPENDS_libgcc-dev += "${@['',get_mlprovides('libgcc-dev', d)][d.getVar('MLPREFIX', True) == '']}"
RDEPENDS_libgcc-dev += "${@['','base-libgcc'][d.getVar('MLPREFIX', True) == '']}"

RPROVIDES_libgcc-dev += "${@['',get_mlprovides('base-libgcc-dev', d)][d.getVar('MLPREFIX', True) == '']}"

RDEPENDS_${PN}-dev += "${@['','base-glibc-dev'][d.getVar('MLPREFIX', True) != '']} ${@['',get_mlprovides('glibc-dev', d)][d.getVar('MLPREFIX', True) == '']}"
RPROVIDES_${PN}-dev += "${@['',get_mlprovides('base-glibc-dev',d)][d.getVar('MLPREFIX', True) == '']}"

RDEPENDS_libstdc++-dev += "${@['','base-libstdc++-dev'][d.getVar('MLPREFIX', True) != '']} ${@['',get_mlprovides('libstdc++-dev', d)][d.getVar('MLPREFIX', True) == '']}"
RPROVIDES_libstdc++-dev += "${@['',get_mlprovides('base-libstdc++-dev', d)][d.getVar('MLPREFIX', True) == '']}"

RDEPENDS_glibc-thread-db += "${@['','base-glibc-thread-db'][d.getVar('MLPREFIX', True) != '']} ${@['',get_mlprovides('glibc-thread-db', d)][d.getVar('MLPREFIX', True) == '']}"
RPROVIDES_glibc-thread-db += "${@['',get_mlprovides('base-glibc-thread-db', d)][d.getVar('MLPREFIX', True) == '']}"
