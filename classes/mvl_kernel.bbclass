SECTION = "kernel"
LICENSE = "GPLv2"

# Use "git apply" because it honors execute permissions of created scripts
PATCHTOOL = "git"

inherit kernel

QAPATHTEST[arch]=""

EXTERNAL ?= ""
PRECONFIGURE_PREFIX ?= "KERNEL_"
KERNEL_CONFIG ?= "${@if_external(d, '${DEF_EXTERNAL_CONFIG}', '${DEF_KERNEL_CONFIG}')}"
KERNEL_PATCH_SERIES ?= "${@if_external(d, '${DEF_EXTERNAL_PATCH_SERIES}', '${DEF_KERNEL_PATCH_SERIES}')}"
KERNEL_PROC_BITBAKE_ENV ?= 'SRC_URI'
do_preconfigure[vardeps] += "KERNEL_CONF_LIST"
KERNEL_LD="${CCACHE}${HOST_PREFIX}ld.bfd ${HOST_LD_KERNEL_ARCH} ${TOOLCHAIN_OPTIONS}"
KERNEL_CC="${CCACHE}${HOST_PREFIX}gcc ${HOST_CC_KERNEL_ARCH} ${TOOLCHAIN_OPTIONS}"
S = "${WORKDIR}/${KERNEL_BASE}"
# Pullin dtb support
include recipes-kernel/linux/linux-dtb.inc

PACKAGES =+ "kernel-src kernel-map"
FILES_kernel-src = "/usr/src/linux.tar.gz"
FILES_kernel-map = "/boot/System.map-* /boot/config-* /boot/kenv.sh /boot/sdk"
RDEPENDS_kernel-dev += "kernel-map"
RDEPENDS_kernel-modules += "kernel-map kmod"
RDEPENDS_kernel-image += "kernel-map"
RDEPENDS_kernel += "kernel-image"
FILES_${PN} = ""
DEPENDS += "bc-native meta-toolchain-scripts"
FILES_kernel-image += "/boot/vmlinuz-*"
python do_patch() {
    import oe.patch
    work=d.getVar("WORKDIR",True)
    series=open("%s/series" % work,"w")
    for patch in src_patches(d):
        _, _, local, _, _, parm = bb.fetch.decodeurl(patch)
        series.write("%s %s\n" % (local, parm['striplevel']))
    series.close()
    bb.build.exec_func("kpatch_it", d)
}

python do_unpack () {
    src_uri = (d.getVar('SRC_URI', True) or "").split()
    if len(src_uri) == 0:
        return
    sourcedir=d.getVar('S', True)
    if os.path.isdir("%s/.pc" % sourcedir):
      version=d.getVar('PV', True)
      for i in range(len(src_uri)):
         if src_uri[i].endswith("linux-%s.tar.bz2" % version):
           src_uri.remove(src_uri[i])
           break
      print "Not unpacking kernel tarball since the sources already exist. Run clean to restart source directory."
    localdata = bb.data.createCopy(d)
    bb.data.update_data(localdata)

    rootdir = localdata.getVar('WORKDIR', True)

    try:
        fetcher = bb.fetch2.Fetch(src_uri, localdata)
        fetcher.unpack(rootdir)
    except bb.fetch2.BBFetchException, e:
        raise bb.build.FuncFailed(e)
}


kpatch_it (){
    cd ${S}
    mkdir -p .pc
    cat ${WORKDIR}/series | while read PATCH STRIPLEVEL; do 
       echo $PATCH
       if [ ! -e .pc/$(basename $PATCH) ] ; then
          git --git-dir=. apply -p$STRIPLEVEL < $PATCH
          ln -s $PATCH .pc
       else
          echo $PATCH already applied
       fi
    done
}
def if_external(d, iftrue, iffalse):
    if d.getVar("EXTERNAL", False):
        return iftrue
    else:
        return iffalse

def get_kernel_config_env(d):
    preconfigure_prefix = d.getVar('PRECONFIGURE_PREFIX')
    prefix_len = len(preconfigure_prefix)
    startswith_var = preconfigure_prefix + 'CONFIG_'
    new_var = []
    for var in d.keys():
        if var.startswith(startswith_var):
            val = d.getVar(var)
            new_var += [var + "=" + val]
    new_var.sort()
    return " ".join(new_var)

python __anonymous() {
    # This function sets the bitbake variables:
    #     S, SRC_URI, and KERNEL_CONFIG
    # based on the values of the variables:
    #     KERNEL_SOURCE_URI, KERNEL_SOURCE_DIRECTORY, DEF_KERNEL_URI,
    #     KERNEL_CONFIG, DEF_KERNEL_CONFIG, DEF_EXTERNAL_CONFIG,
    #     KERNEL_PATCH_SERIES, KERNEL_APPEND_PATCH_SERIES,
    #     DEF_KERNEL_PATCH_SERIES, DEF_EXTERNAL_PATCH_SERIES, and WORKDIR

    import bb
    def getVar(var):
        return bb.data.getVar(var, d, True)

    def setVar(var, val):
        bb.data.setVar(var, val, d)

    def series_uris(series):
        import re
        import os
        filedir=bb.data.getVar('FILE_DIRNAME',d,True)
        dirname = os.path.dirname(series)
        uris = []
        f = open(series, 'r')
        for line in f:
                patch = re.sub(r'#.*', '', line).strip()
                if not patch:
                    continue
                if not patch.startswith('/'):
                    patch = os.path.join(dirname, patch)
                patch = patch.replace(filedir,'${FILE_DIRNAME}')
                bb.debug(2, 'Patch file: %s' % patch)
                uris.append('file://%s' % patch)

        f.close()
        return uris

    kernel_uri = getVar('KERNEL_SOURCE_URI')
    kernel_dir = getVar('KERNEL_SOURCE_DIRECTORY')
    if kernel_uri:
        kernel_dir = None
    elif kernel_dir:
        if not os.path.isdir(kernel_dir):
           bb.fatal("KERNEL_SOURCE_DIRECTORY is set to a directory value that appears not to exist.")
        kernel_uri = 'file://%s' % os.path.basename(os.path.abspath(kernel_dir))
        extra_paths=getVar('FILESEXTRAPATHS')
        setVar('FILESEXTRAPATHS',"%s:%s" % ( os.path.dirname(os.path.abspath(kernel_dir)), extra_paths))

    if kernel_uri:
        setVar("EXTERNAL", "1")
    else:
        kernel_uri = getVar('DEF_KERNEL_URI')

    if kernel_uri.startswith('git:') or 'protocol=git' in kernel_uri:
        kernel_base = 'git'
    else:
        kernel_base = os.path.basename(kernel_uri)

    if not kernel_dir:
        suffixes = ('.tar', '.tgz', '.tar.gz', '.tbz', 'tbz2', '.tar.bz2','.tar.xz')
        for suffix in suffixes:
            if kernel_base.endswith(suffix):
                kernel_base = kernel_base[:-len(suffix)]
                break

    setVar("KERNEL_BASE", kernel_base)

    series = getVar('KERNEL_PATCH_SERIES')
    append_series = getVar('KERNEL_APPEND_PATCH_SERIES') or ""
    src_uri = (d.getVar('SRC_URI', True) or "").split()
    src_uris = [kernel_uri]
    for series in series.split() + append_series.split():
        bb.debug(1, 'Patch series file: %s' % series)
        src_uris += series_uris(series)
    src_uri = ' '.join(src_uris) + " " + " ".join(src_uri)

    setVar('SRC_URI', src_uri)
    setVar('KERNEL_CONF_LIST',get_kernel_config_env(d)) 

    devicetree = d.getVar("KERNEL_DEVICETREE", True) or ''
    if devicetree:
        depends = d.getVar("RDEPENDS_kernel-image", True)
        d.setVar("RDEPENDS_kernel-image", "%s kernel-devicetree" % depends)

}

addtask do_kernel_source_shared after do_patch before do_preconfigure
# Copy pristine kernel source into the shared area,
# i.e tmp/work-shared/MACHINE/kernel-source (alias STAGING_KERNEL_DIR)
do_kernel_source_shared () {
    cp -rf ${S}/*  ${STAGING_KERNEL_DIR}/
}

python do_preconfigure() {
    # This function writes:
    #     ${S}/localversion
    #     ${S}/.config
    #     ${S}/fs/proc/static/files/bitbake/env.gz (/proc/bitbake/env.gz)

    import bb
    import os
    import re
    import tempfile

    def getVar(var):
        return bb.data.getVar(var, d, True)

    def get_collection_version(name):
        collectionsinfo = getVar('COLLECTIONSINFO')
        if collectionsinfo:
            for info in getVar('COLLECTIONSINFO').itervalues():
                    if info['name'] == name:
                        return info['version']
            return ''

    def write_localversion(filename):
        msd = getVar('MSD')
        pv = getVar('PV')
        msdname = re.sub('-%s$' % pv, '', msd)
        localversion = '.' + msdname
        kernel_collection_version = get_collection_version(msd)
        if kernel_collection_version:
            localversion += '.' + kernel_collection_version.lower()
        f = open(filename, 'w')
        f.write('%s\n' % localversion)
        f.close
        bb.debug(1, '%s: %s' % (filename, localversion))

    def get_kernel_config_vars():
        preconfigure_prefix = getVar('PRECONFIGURE_PREFIX')
        prefix_len = len(preconfigure_prefix)
        startswith_var = preconfigure_prefix + 'CONFIG_'
        new_vars = {}
        for var in d.keys():
            if var.startswith(startswith_var):
                val = getVar(var)
                bb.debug(2, 'config: %s=%s' % (var, val))
                var = var[prefix_len:]
                new_vars[var] = val
        return new_vars

    def copy_config(config, new_config, new_vars={}):
        def write_config_line(f, var, val):
            if val == 'n':
                line = '# %s is not set' % var
            else:
                if not re.match(r'y$|m$|["0-9]', val):
                    val = '"%s"' % val
                line = '%s=%s' % (var, val)
            bb.debug(1, 'updating kernel config: %s' % line)
            f.write('%s\n' % line)

        bb.debug(1, 'Copying config from %s to %s' % (config, new_config))
        fd, tmp_config = tempfile.mkstemp('w', dir=os.path.dirname(new_config))
        nf = os.fdopen(fd, 'w')
        f = open(config)
        new_vars = new_vars.copy()

        config_var_pat = r'CONFIG_[A-Z0-9_]+'
        re_commented_var = re.compile(r'# (%s) is not set$' % config_var_pat)
        re_var_value = re.compile(r'(%s)=' % config_var_pat)

        for line in f:
            line = line.rstrip('\n')
            bb.debug(2, 'existing kernel config: %s' % line)
            match = re_var_value.match(line) or re_commented_var.match(line)
            if match:
                var = match.group(1)
            else:
                var = None

            if var != None and var in new_vars:
                write_config_line(nf, var, new_vars[var])
                del new_vars[var]
            else:
                nf.write('%s\n' % line)

        for var in new_vars:
            write_config_line(nf, var, new_vars[var])

        f.close()
        nf.close()
        os.rename(tmp_config, new_config)

    def add_bitbake_env():
        import gzip
        import errno

        env_vars = getVar('KERNEL_PROC_BITBAKE_ENV')
        if not env_vars:
            bb.debug(1, 'KERNEL_PROC_BITBAKE_ENV is empty')
            return

        procname = 'bitbake/env.gz'
        relname = os.path.join('fs/proc/static/files', procname)
        filename = os.path.join(getVar('S'), relname)

        bb.utils.mkdirhier(os.path.dirname(filename))

        f = gzip.open(filename, 'wb', 9)
        bb.debug(1, 'Created %s' % filename)
        for var in env_vars.split():
            value = getVar(var)
            f.write('%s="%s"\n' % (var, value.replace('"', r'\"')))
            bb.debug(2, 'Added %s to %s' % (var, filename))
        f.close()

    s = getVar('S')

    localversion = os.path.join(s, 'localversion')
    if not os.path.exists(localversion):
        write_localversion(localversion)

    config = getVar('KERNEL_CONFIG')
    if not os.path.isabs(config):
        config = os.path.join(s, config)
    new_config = os.path.join(s, '.config')
    new_vars = get_kernel_config_vars()
    copy_config(config, new_config, new_vars)
    add_bitbake_env()
}

addtask preconfigure after do_patch before do_configure

mvl_kernel_do_devshell() {
     source ${EMIT_SHELLSCRIPT_KFN}
     devshell_do_devshell
}
addtask devshell after do_preconfigure

#require recipes-kernel/linux/linux-tools.inc

do_install_append () {
     rm -f ${D}/usr/src/kernel/tools/perf/perf

     # relocs is only used for building the x86 vmlinux, so it's not
     # required.  Having it causes a .debug to be created, which
     # screws up packaging.
     rm -f ${D}/usr/src/kernel/arch/x86/tools/relocs
     rm -f ${D}/usr/src/kernel/arch/arm64/kernel/vdso/*.so
     rm -f ${D}/usr/src/kernel/arch/arm64/kernel/vdso/*.dbg

     if [ "${KERNEL_IMAGETYPE}" = "bzImage" ] ; then
       ln -s -f bzImage-${KERNEL_VERSION} ${D}/boot/vmlinuz-${KERNEL_VERSION}
     fi
}

do_compile_perf () {
        if [ "${BUILDPERF}" = "yes" ]; then
                oe_runmake -C ${S}/tools/perf CC="${CC} ${CFLAGS}" LD="${LD}" prefix=${prefix} NO_NEWT=1 NO_DWARF=1 NO_GTK2=1 NO_LIBPERL=1 NO_LIBPYTHON=1
                    fi
}

fakeroot do_install_perf () {
        if [ "${BUILDPERF}" = "yes" ]; then
                oe_runmake -C ${S}/tools/perf CC="${CC} ${CFLAGS}" LD="${LD}" prefix=${prefix} DESTDIR=${D} install NO_NEWT=1 NO_DWARF=1 NO_GTK2=1 NO_LIBPERL=1 NO_LIBPYTHON=1
        fi
}

do_install_prepend () {
        install -d ${D}${KERNEL_SRC_PATH}
        install -d ${D}/boot
        kvnsh=${D}${KERNEL_SRC_PATH}/kenv.sh
        kernel_arch="${TARGET_CC_KERNEL_ARCH}"
        if [ -z "$kernel_arch" ] ; then
            kernel_arch="${TARGET_CC_ARCH}"
        fi
        echo 'export ARCH="${@map_kernel_arch(d.getVar("TARGET_ARCH", 1), d)}"' > $kvnsh
        echo "export KCFLAGS=\"$kernel_arch\"" >> $kvnsh
        echo 'export CROSS_COMPILE="${TARGET_PREFIX}"' >> $kvnsh
        echo 'export KERNEL_CC="${KERNEL_CC}"' >> $kvnsh
        echo 'export KERNEL_LD="${KERNEL_LD}"' >> $kvnsh
        echo 'export KERNEL_AR="${KERNEL_AR}"' >> $kvnsh
        echo 'export KERNEL_IMAGETYPE="${KERNEL_IMAGETYPE}"' >> $kvnsh
        echo 'export KERNEL_OUTPUT="arch/${ARCH}/boot/${KERNEL_IMAGETYPE}"' >> $kvnsh
        echo 'export KMACHINE="${MACHINE}"' >> $kvnsh
        echo 'export UBOOT_ENTRYPOINT="${UBOOT_ENTRYPOINT}"' >> $kvnsh
        echo 'export PN="${PN}"' >> $kvnsh
        echo 'export PV_BASE="${PV}"' >> $kvnsh
        echo 'export PR="${PR}"' >> $kvnsh
        echo 'export MSDVERSION="${MSD_VERSION}"' >> $kvnsh
        echo "export KERNEL_EXTRA_ARGS='${KERNEL_EXTRA_ARGS}'" >> $kvnsh
	echo 'export MVL_TOOL_DIR="${MVL_TOOL_DIR}"'
        echo "export TOOL_PREFIX=\"/tools/${MVL_TOOL_DIR}/bin:\"" >> $kvnsh
        cp ${D}${KERNEL_SRC_PATH}/kenv.sh ${D}/boot/ 
        install -d ${D}/boot/sdk
        install -d ${D}${KERNEL_SRC_PATH}/sdk
        if [ -d ${STAGING_DIR_TARGET}${includedir}/mv-sdk/ ] ; then
           cp ${STAGING_DIR_TARGET}${includedir}/mv-sdk/* ${D}/boot/sdk
           cp ${STAGING_DIR_TARGET}${includedir}/mv-sdk/* ${D}${KERNEL_SRC_PATH}/sdk
        elif [ -d sdk ] ; then
           cp sdk/* ${D}/boot/sdk
           cp sdk/* ${D}${KERNEL_SRC_PATH}/sdk
        fi
}

kernel_do_deploy() {
	if [ "x$KERNEL_IMAGE_BASE_NAME_SH" = "x" ] ; then
		KERNEL_IMAGE_BASE_NAME_SH=${KERNEL_IMAGE_BASE_NAME}
	fi
	if [ "x$KERNEL_IMAGE_SYMLINK_NAME_SH" = "x" ] ; then
		KERNEL_IMAGE_SYMLINK_NAME_SH=${KERNEL_IMAGE_SYMLINK_NAME}
	fi
	BASE_NAME=$(echo $KERNEL_IMAGE_BASE_NAME_SH | cut -d - -f 2-)
	BASE_SYMLINK_NAME=$(echo $KERNEL_IMAGE_SYMLINK_NAME_SH | cut -d - -f 2-)
	install -d ${DEPLOYDIR}
	if [ -e vmlinux ] ; then
		install -m 0644 vmlinux ${DEPLOYDIR}/vmlinux-$BASE_NAME
	fi
	install -m 0644 ${KERNEL_OUTPUT} ${DEPLOYDIR}/$KERNEL_IMAGE_BASE_NAME_SH.bin
	if [ ${MODULE_TARBALL_DEPLOY} = "1" ] && (grep -q -i -e '^CONFIG_MODULES=y$' .config); then
		mkdir -p ${D}/lib
		tar -cvzf ${DEPLOYDIR}/${MODULE_TARBALL_BASE_NAME} -C ${D} lib
		ln -sf ${MODULE_TARBALL_BASE_NAME}.bin ${MODULE_TARBALL_SYMLINK_NAME}
	fi

	cd ${DEPLOYDIR}
	rm -f $KERNEL_IMAGE_SYMLINK_NAME_SH.bin
	ln -sf $KERNEL_IMAGE_BASE_NAME_SH.bin $KERNEL_IMAGE_SYMLINK_NAME_SH.bin
	ln -sf $KERNEL_IMAGE_BASE_NAME_SH.bin ${KERNEL_IMAGETYPE}

	rm -f vmlinux-$BASE_SYMLINK_NAME
	ln -sf vmlinux-$BASE_NAME vmlinux-$BASE_SYMLINK_NAME


	cp ${COREBASE}/meta/files/deploydir_readme.txt ${DEPLOYDIR}/README_-_DO_NOT_DELETE_FILES_IN_THIS_DIRECTORY.txt
	cd -
}

do_initramfs () {
       if [ "x${INITRAMFS_IMAGE}" = "x" ] ; then
               exit 0
       fi
       if [ ! -e .config.noninitramfs ] ; then
               cp .config .config.noninitramfs
       fi
       cat .config.noninitramfs | sed /CONFIG_INITRAMFS_SOURCE/d > .config
       echo CONFIG_INITRAMFS_SOURCE=\"${DEPLOY_DIR_IMAGE}/${INITRAMFS_IMAGE}-${MACHINE}.cpio.gz\" >> .config
       kernel_do_configure
       kernel_do_compile
       export KERNEL_IMAGE_BASE_NAME_SH="${KERNEL_IMAGE_BASE_NAME}-${INITRAMFS_IMAGE}"
       export KERNEL_IMAGE_SYMLINK_NAME_SH="${KERNEL_IMAGE_SYMLINK_NAME}-${INITRAMFS_IMAGE}"
       do_deploy
}

do_makewritable () {
       chmod -R u+w ${S}
}

addtask makewritable before do_patch after do_unpack

do_initramfs[depends] = "${INITRAMFS_TASK}"
do_initramfs[nostamp] = "1"
addtask initramfs before do_deploy after do_package

def fix_up_pkgconfig (d):
    d.setVar("PKG_CONFIG_DIR", "%s/%s/pkgconfig" % (d.getVar("STAGING_DIR_NATIVE", True), d.getVar("libdir_native", True)))
    kcflags = d.getVar("TARGET_CC_KERNEL_ARCH",True)
    if not kcflags:
       kcflags = d.getVar("TARGET_CC_ARCH", True) or "" 
    d.setVar("KCFLAGS", kcflags)
    oeterm_exports = d.getVar("OE_TERMINAL_EXPORTS", True)
    oeterm_exports += " PKG_CONFIG_DIR PKG_CONFIG_PATH PKG_CONFIG_LIBDIR PKG_CONFIG_SYSROOT_DIR KCFLAGS" 
    d.setVar("OE_TERMINAL_EXPORTS", oeterm_exports)

python do_devshell_prepend () {
    fix_up_pkgconfig (d)
}
python do_menuconfig_prepend () {
    fix_up_pkgconfig (d)
}
