#
# Configuration to use external MVL toolchain
#
# MontaVista Version of CS external toolchain mode.
#
#

#Disable task for a until its cleaned up.
TOOLCHAIN_HOST_TASK="nativesdk-packagegroup-sdk-host meta-environment-${MACHINE}"
MVL_TOOLS_TOPLEVEL_PREFIX ?='${@os.path.dirname(mvl_whereami(d))}/../tools'
include conf/toolchain/base/${MVL_ARCH_TOOLCHAIN}.conf
EXTERNAL_TOOLCHAIN ?= "${MVL_SDK_PREFIX}"
TOOLCHAIN_PATH = "${EXTERNAL_TOOLCHAIN}/bin/${TOOLCHAIN_DIR}/"
TOOLCHAIN_PATH_ADD = "${TOOLCHAIN_PATH}:"
PATH =. "${TOOLCHAIN_PATH_ADD}"
export OBJCOPY_class-target ="${TOOLCHAIN_PATH}/${HOST_PREFIX}objcopy"
export OBJDUMP_class-target ="${TOOLCHAIN_PATH}/${HOST_PREFIX}objdump"
export STRIP_class-target ="${TOOLCHAIN_PATH}/${HOST_PREFIX}strip"

EXTERNAL_GLIBC ?= "1"

COMPATIBLE_HOST_pn-glibc = "${@base_conditional('EXTERNAL_GLIBC', '1', '${SDK_SYS}' , '(.*)', d)}"
MV_GLIBC="${@base_conditional('EXTERNAL_GLIBC', '1', 'external-mvl-toolchain' , 'glibc', d)}"
#MV_KERNEL_HEADER="${@base_conditional('EXTERNAL_GLIBC', '1', 'external-mvl-toolchain', 'linux-libc-headers' , d)}"
MV_KERNEL_HEADER="external-mvl-toolchain"
PREFERRED_VERSION_glibc ?= "${@base_conditional('EXTERNAL_GLIBC', '1', '', '2.21' , d)}"

PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}gcc = "external-mvl-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}gcc-initial = "external-mvl-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}gcc-intermediate = "external-mvl-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}g++ = "external-mvl-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}binutils = "external-mvl-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}compilerlibs = "external-mvl-toolchain"
PREFERRED_PROVIDER_libgcc = "external-mvl-toolchain"
PREFERRED_PROVIDER_virtual/linux-libc-headers = "${MV_KERNEL_HEADER}"
PREFERRED_PROVIDER_binutils-cross = "external-mvl-toolchain"
PREFERRED_PROVIDER_gcc-cross = "external-mvl-toolchain"
PREFERRED_PROVIDER_gdb-cross = "external-mvl-toolchain"
PREFERRED_PROVIDER_libc-mtrace = "external-mvl-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}libc-initial= 'external-mvl-toolchain'
PREFERRED_PROVIDER_virtual/libiconv-nativesdk = 'external-mvl-toolchain'

PREFERRED_PROVIDER_virtual/libiconv_mvista-cgx = "${MV_GLIBC}"
PREFERRED_PROVIDER_virtual/libintl_mvista-cgx = "gettext"
PREFERRED_PROVIDER_linux-libc-headers = "${MV_KERNEL_HEADER}"
PREFERRED_PROVIDER_linux-libc-headers-dev = "${MV_KERNEL_HEADER}"
PREFERRED_PROVIDER_virtual/libc = "${MV_GLIBC}"
PREFERRED_PROVIDER_glibc = "${MV_GLIBC}"
PREFERRED_PROVIDER_glibc-thread-db = "${MV_GLIBC}"
PREFERRED_PROVIDER_linux-libc-headers = "${MV_KERNEL_HEADER}"
PREFERRED_PROVIDER_virtual/libc-nativesdk = "${MV_GLIBC}"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}libc-for-gcc = "${MV_GLIBC}"
#FIX ME: this needs to be cleaned up. It should be mostly uneeded if --sysroot works correctly

TOOLCHAIN_OPTIONS=" --sysroot=${STAGING_DIR_TARGET} "
BBMASK ?= "(catchemptybbmask)"
BBMASK .= "|(meta/external-csl-toolchain)|(meta/external-sourcery-toolchain)"
#FIX ME
MV_TAR_RELEASE ?= "${@mvl_toolchain_tar_version(d)}"
MV_TAR_RELEASE="150303"
def mvl_toolchain_tar_version(d):
    import glob
    toolchain=d.getVar("EXTERNAL_TOOLCHAIN", True)
    files=glob.glob("%s/sources/gcc*.tar.bz2" % (toolchain))
    files.sort(reverse=True) # Make sure to get the newest version
    gcc=os.path.basename(files[0])
    return gcc.split(".")[-3]

def mvl_whereami(d):
    import bb.process
    import subprocess
    topdir = d.getVar('TOPDIR', True)
    try:
       path=bb.process.run(["which","bitbake"], cwd=topdir, stderr=subprocess.PIPE)[0]
    except:
       return  ""
    return path
# Translate to CodeSourcery's names for their optimized files in the toolchain
def csl_target_core(d):
    coredata = {
        'armv7a-vfp-neon': 'armv7-a-neon',
        'i586': 'sgxx-glibc',
        'i686': 'sgxx-glibc',
        'mips': 'mips32',
        'mipsel': 'el',
        'powerpc-nf': 'nof',
        'ppce500': 'te500v1',
        'ppce500mc': 'te500mc',
        'ppce500v2': 'te500v2',
        'ppce600': 'te600'
    }
    return coredata.get(d.getVar('TUNE_PKGARCH', True), '')

CSL_TARGET_CORE = "${@csl_target_core(d)}"

# Unfortunately, the CSL ia32 toolchain has non-prefixed binaries in its
# bindir (e.g. gcc, ld). To avoid this messing up our build, we avoid adding
# this bindir to our PATH, and instead add symlinks to the prefixed binaries
# to our staging toolchain bindir.

python toolchain_metadata_setup () {
    if not isinstance(e, bb.event.ConfigParsed):
        return

    d = e.data

    if d.getVar('TUNE_PKGARCH', True) in ('i586', 'i686'):
        d.setVar('TOOLCHAIN_PATH_ADD', '')
}
addhandler toolchain_metadata_setup

python toolchain_setup () {
    if not isinstance(e, bb.event.BuildStarted):
        return

    d = e.data

    if d.getVar('TUNE_PKGARCH', True) in ('i586', 'i686'):
        populate_toolchain_links(d)
}
addhandler toolchain_setup

def populate_toolchain_links(d):
    import errno
    import os
    from glob import glob

    d = d.createCopy()
    d.finalize()

    pattern = d.expand('${EXTERNAL_TOOLCHAIN}/bin/${TARGET_PREFIX}*')
    files = glob(pattern)

    bindir = d.getVar('STAGING_BINDIR_TOOLCHAIN', True)
    bb.mkdirhier(bindir)
    for f in files:
        base = os.path.basename(f)
        newpath = os.path.join(bindir, base)
        try:
            os.symlink(f, newpath)
        except OSError as exc:
            if exc.errno == errno.EEXIST:
                break
            bb.fatal("Unable to populate toolchain binary symlink for %s: %s" % (newpath, exc))

require conf/distro/include/mvl-versions.inc
