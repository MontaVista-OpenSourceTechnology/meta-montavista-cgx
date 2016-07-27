python package_name_hook () {
    pass
}

DEBIANRDEP = "do_packagedata"
do_package_write_ipk[rdeptask] = "${DEBIANRDEP}"
do_package_write_deb[rdeptask] = "${DEBIANRDEP}"
do_package_write_tar[rdeptask] = "${DEBIANRDEP}"
do_package_write_rpm[rdeptask] = "${DEBIANRDEP}"

python () {
    if not d.getVar("PACKAGES", True):
        d.setVar("DEBIANRDEP", "")
#   Remove CSL_VER_MAIN     
    toolchainflags = d.getVarFlag('TOOLCHAIN_OPTIONS', 'vardeps', True) or ""
    d.setVarFlag('TOOLCHAIN_OPTIONS', 'vardeps' , toolchainflags.replace('CSL_VER_MAIN',''))
    if bb.data.inherits_class("kernel",d):
       configs=get_kernel_config_env(d)
       if configs:
          d.setVar('KERNEL_CONF_LIST',get_kernel_config_env(d)) 
          bb.build.addtask('do_kernel_postconfigure', 'do_compile', 'do_configure', d)
    if bb.data.inherits_class("module",d) and d.getVar("MULTILIB_VARIANTS", True) != "":
          errorQA = d.getVar("ERROR_QA", True)
          errorList = errorQA.split()
          if 'arch' in errorList:
             errorList.remove('arch')
             errorQA = " ".join(errorList)
             d.setVar("ERROR_QA", errorQA)
          
}
SDKTARGETSYSROOT_mvista-cgx="${SDKPATH}/sysroots/${MACHINE}-montavista-linux"

toolchain_create_sdk_env_script_append () {
	rm -f $script
	touch $script
	echo 'if [ -z "${SDK_ROOT}" ] ; then' >> $script
	echo '   SDK_ROOT="${SDKTARGETSYSROOT}"' >> $script
	echo 'fi' >> $script
	echo 'if [ -z "${SDK_PATH_NATIVE}" ] ; then' >> $script
	echo '   SDK_PATH_NATIVE="${SDKPATHNATIVE}"' >> $script
	echo '   export OECORE_NATIVE_SYSROOT="${SDKPATHNATIVE}"' >> $script
        echo 'else' >> $script
	echo '   export OECORE_NATIVE_SYSROOT="${SDK_PATH_NATIVE}"' >> $script
	echo 'fi' >> $script
	echo 'export TARGET_PREFIX="${TARGET_PREFIX}"' >> $script
	echo 'export MVL_TOOL_DIR="${MVL_TOOL_DIR}"' >> $script
	echo 'export CSL_TARGET_SYS="${CSL_TARGET_SYS}"' >> $script
	echo 'COMPILER=$(which $(echo ${TARGET_PREFIX})gcc 2>/dev/null)' >> $script
	echo 'BITBAKE=$(which bitbake 2>/dev/null)' >> $script
	echo '' >> $script
        echo 'if [ -z "${COMPILER}" -a -n "${BITBAKE}" ] ; then' >> $script
        echo '     PATH_SAVE=$PATH' >> $script
        echo '     CCPATH=$(dirname $(dirname ${BITBAKE}))/tools/${MVL_TOOL_DIR}/bin' >> $script
        echo '     export PATH=${CCPATH}:${PATH_SAVE}' >> $script
        echo '     COMPILER=$(which $(echo ${TARGET_PREFIX})gcc 2>/dev/null)' >> $script
        echo '     if [ -z "${COMPILER}" ] ; then' >> $script
        echo '        export PATH=${PATH_SAVE}' >> $script
        echo '     fi' >> $script
        echo 'fi' >> $script
        echo '' >> $script
	echo 'export PATH=${SDK_PATH_NATIVE}${bindir_nativesdk}:${SDK_PATH_NATIVE}${bindir_nativesdk}/${REAL_MULTIMACH_TARGET_SYS}:$PATH' >> $script
        echo 'if [ -n "${COMPILER}" ] ; then' >> $script
        echo 'if [ -z "${TOOL_ROOT}" ] ; then' >> $script
        echo '   TOOL_ROOT=$(dirname $(dirname ${COMPILER}))' >> $script
        echo 'fi' >> $script
        echo 'export TOOL_INCLUDE=${TOOL_ROOT}/${CSL_TARGET_SYS}/sys-root/usr/include' >> $script
	echo 'export PKG_CONFIG_SYSROOT_DIR=${SDK_ROOT}' >> $script
	echo 'export PKG_CONFIG_PATH=${SDK_ROOT}${libdir}/pkgconfig' >> $script
	echo 'export CONFIG_SITE=${SDKPATH}/site-config-${REAL_MULTIMACH_TARGET_SYS}' >> $script
	echo 'export CC="${TARGET_PREFIX}gcc ${TARGET_CC_ARCH} --sysroot=${SDK_ROOT}"' >> $script
	echo 'export CXX="${TARGET_PREFIX}g++ ${TARGET_CC_ARCH} --sysroot=${SDK_ROOT}"' >> $script
	echo 'export CPP="${TARGET_PREFIX}gcc -E ${TARGET_CC_ARCH} --sysroot=${SDK_ROOT}"' >> $script
	echo 'export AS="${TARGET_PREFIX}as ${TARGET_AS_ARCH}"' >> $script
	echo 'export LD="${TARGET_PREFIX}ld ${TARGET_LD_ARCH} --sysroot=${SDK_ROOT}"' >> $script
	echo 'export GDB=${TARGET_PREFIX}gdb' >> $script
	echo 'export STRIP=${TARGET_PREFIX}strip' >> $script
	echo 'export RANLIB=${TARGET_PREFIX}ranlib' >> $script
	echo 'export OBJCOPY=${TARGET_PREFIX}objcopy' >> $script
	echo 'export OBJDUMP=${TARGET_PREFIX}objdump' >> $script
	echo 'export AR=${TARGET_PREFIX}ar' >> $script
	echo 'export NM=${TARGET_PREFIX}nm' >> $script
	echo 'export CONFIGURE_FLAGS="--target=${TARGET_SYS} --host=${TARGET_SYS} --build=${SDK_ARCH}-linux --with-libtool-sysroot=${SDK_ROOT}"' >> $script
	echo 'export CFLAGS=$(echo ${TARGET_CFLAGS} | sed -e "s|##STAGINGDIRTARGET##|${SDK_ROOT}|g" -e "s|##MVLSDKPREFIX##|${TOOL_ROOT}/|g")' >> $script
	echo 'export CXXFLAGS=$(echo ${TARGET_CXXFLAGS} | sed -e "s|##STAGINGDIRTARGET##|${SDK_ROOT}|g" -e "s|##MVLSDKPREFIX##|${TOOL_ROOT}/|g")' >> $script
	echo 'export LDFLAGS=$(echo ${TARGET_LDFLAGS} | sed -e "s|##STAGINGDIRTARGET##|${SDK_ROOT}|g" -e "s|##MVLSDKPREFIX##|${TOOL_ROOT}/|g")' >> $script
	echo 'export CPPFLAGS=$(echo ${TARGET_CPPFLAGS} | sed -e "s|##STAGINGDIRTARGET##|${SDK_ROOT}|g" -e "s|##MVLSDKPREFIX##|${TOOL_ROOT}/|g") ' >> $script
	echo 'export ARCH=${ARCH}' >> $script
	echo 'else' >> $script
        echo ' echo "Could not find external toolchain $(echo ${TARGET_PREFIX})gcc. Please add path to toolchain install."' >> $script
	echo 'fi' >> $script
	echo 'export OECORE_TARGET_SYSROOT="${SDK_ROOT}"' >> $script
        echo 'export OECORE_ACLOCAL_OPTS="-I ${SDK_PATH_NATIVE}/usr/share/aclocal"' >> $script
	echo 'export OECORE_DISTRO_VERSION="${DISTRO_VERSION}"' >> $script
	echo 'export OECORE_SDK_VERSION="${SDK_VERSION}"' >> $script

	# Replace ${MVL_SDK_PREFIX} and ${STAGING_DIR_TARGET} 
	# with ##MVLSDKPREFIX## and ##STAGINGDIRTARGET## respectively 
	# to avoid populating actual paths in environment-setup-* scripts.
	# Replace $PATH with ${PATH}.
	RAW_PATH1="$"
	RAW_PATH2="{PATH}"
	sed -i -e "s|${MVL_SDK_PREFIX}|##MVLSDKPREFIX##|g" \
	-e "s|${STAGING_DIR_TARGET}|##STAGINGDIRTARGET##|g" \
	-e "s|\$PATH|${RAW_PATH1}${RAW_PATH2}|g" $script
}

P2BUILDDIR="${WORKDIR}/p2"
P2DIR="${DEPLOY_DIR}/p2/${SDK_ARCH}"
SDK_NAME = "${SDK_NAME_PREFIX}-${MACHINE}-${SDK_ARCH}"
TOOLCHAIN_OUTPUTNAME ?= "${SDK_NAME}-${SDK_VERSION}"
MSD_VERSION ?="${DATETIME}"
PLUGIN_ID ?= "com.mvista.sdk.core-${MACHINE}-${SDK_ARCH}-mvlsdk"
FEATURE_ID ?= "com.mvista.sdk-${MACHINE}-${SDK_ARCH}-mvlsdk"
PLUGIN_NAME ?="MontaVista SDK ${MACHINE}-${SDK_ARCH}"
FEATURE_NAME ?="MontaVista SDK ${MACHINE}-${SDK_ARCH}"
VENDOR_NAME ?= "MontaVista Software, LLC."
ADK_VERSION ?= "2.0.0"
MSD_REVISION ?= "${MSD_VERSION}"

fakeroot create_shar_append_mvista-cgx () {
	# Make sure OECORE_NATIVE_SYSROOT doesn't read user
	# defined SDK_PATH_NATIVE variable during SDK installation.
	sed -i "s:^native_sysroot=\(.*\)OECORE_NATIVE_SYSROOT=\(.*\)|cut\(.*\):native_sysroot=\1OECORE_NATIVE_SYSROOT=\2| grep -v SDK_PATH_NATIVE | cut\3:g" ${T}/post_install_command ${SDK_DEPLOY}/${TOOLCHAIN_OUTPUTNAME}.sh
}

create_shar_append () {
	SDK2P2=$(which sdk2p2)
	if [ -n "$SDK2P2" ] ; then
                mkdir -p ${P2BUILDDIR}/../p2-tmp/
                cp -a $(dirname $SDK2P2)/../share/p2installer ${P2BUILDDIR}/../p2-tmp/
                licensedirs=$(find ${P2BUILDDIR}/../sdk/image/ -type d | grep licenses\$) || true
                if [ -n "$licensedirs" ] ; then
                   liceman -t ${P2BUILDDIR}/../p2-tmp/p2installer/com.mvista.sdk $licensedirs
                fi
		mkdir -p ${P2BUILDDIR}
                bash -x $SDK2P2 -s ${SDK_DEPLOY}/${TOOLCHAIN_OUTPUTNAME}.sh -d ${P2BUILDDIR} \
                -i "${PLUGIN_ID}" -j "${FEATURE_ID}" \
                -f "${FEATURE_NAME}" -p "${PLUGIN_NAME}" \
                -v "${ADK_VERSION}" -q ${MSD_REVISION} -S ${P2BUILDDIR}/../p2-tmp/ -n "${VENDOR_NAME}"
		mkdir -p ${P2DIR}
                cp ${P2BUILDDIR}/*/*.jar ${P2DIR}
                cp ${P2BUILDDIR}/features/*/category.xml ${P2DIR}
	fi
}
	

OE_TERMINAL_EXPORTS += "MVL_SDK_PREFIX PATH"


CORE_IMAGE_BASE_INSTALL_mvista-cgx = '\
    ${@bb.utils.contains("IMAGE_FEATURES", "busyboxless", "packagegroup-core-boot-busyboxless", "packagegroup-core-boot", d)} \
    packagegroup-base-extended \
    ${CORE_IMAGE_EXTRA_INSTALL} \
'


PRECONFIGURE_PREFIX ?= "KERNEL_"
do_kernel_postconfigure[vardeps] += "KERNEL_CONF_LIST"
do_kernel_postconfigure[doc] = "Adds kernel config values from the environment"
def get_kernel_config_env(d):
    preconfigure_prefix = d.getVar('PRECONFIGURE_PREFIX',True)
    prefix_len = len(preconfigure_prefix)
    startswith_var = preconfigure_prefix + 'CONFIG_'
    new_var = []
    for var in d.keys():
        if var.startswith(startswith_var) and var != "KERNEL_CONFIG_COMMAND":
            val = d.getVar(var,True)
            new_var += [var + "=" + val]
    new_var.sort()
    return " ".join(new_var)

python do_kernel_postconfigure() {
    import os
    import re
    import tempfile
    if not bb.data.inherits_class("kernel",d):
       return

    def get_kernel_config_vars():
        preconfigure_prefix = d.getVar('PRECONFIGURE_PREFIX', True)
        prefix_len = len(preconfigure_prefix)
        startswith_var = preconfigure_prefix + 'CONFIG_'
        new_vars = {}
        for var in d.keys():
            if var.startswith(startswith_var) and var != 'KERNEL_CONFIG_BUILD':
                val = d.getVar(var,True)
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
    new_vars = get_kernel_config_vars()
    if new_vars:
        builddir = d.expand(d.getVar('B',True))
        config = os.path.join(builddir,".config")
        if os.path.exists(config):
           save = config + ".mvsave"
           open(save, "w").write(open(config).read())
           copy_config(save, config, new_vars)
           bb.build.exec_func("kernel_reconfigure", d)
}

kernel_reconfigure () {
   eval ${KERNEL_CONFIG_COMMAND}
}

do_make_scripts[depends] += "openssl-native:do_populate_sysroot"
do_make_scripts_mvista-cgx() {
        unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
        make CC="${KERNEL_CC}" LD="${KERNEL_LD}" AR="${KERNEL_AR}" \
                   -C ${STAGING_KERNEL_DIR} O=${STAGING_KERNEL_BUILDDIR} \
                   HOSTCC='gcc -I${STAGING_INCDIR_NATIVE} -L${STAGING_DIR_NATIVE}/lib -Wl,-rpath,${STAGING_DIR_NATIVE}/lib' \
                   scripts
}

# KERNEL_INTERNAL_CFG_LOCATION holds location of internal 
# kernel fragment files (.cfg files)
KERNEL_INTERNAL_CFG_LOCATION := "${@ bb.data.getVar("MVLBASE",d,1)}/recipes-kernel/linux/cfg-files/"

# KERNEL_CFG_LOCATION contains internal kernel fragment files (.cfg files)
# EXTRA_CFG_DIRECTORY_LIST contains list of directories containing external 
# kernel fragment files (.cfg files). The list is delimited by colon (:).
EXTRA_KERNEL_CFG_DIRECTORY_LIST ?= ""
KERNEL_CFG_LOCATION := "${@ bb.data.getVar("MVLBASE",d,1)}/recipes-kernel/linux/cfg-files/:${EXTRA_KERNEL_CFG_DIRECTORY_LIST}"

# KERNEL_CFG_AVAILABLE - lists available internal and external kernel fragment 
# files via getCfgs function
def getCfgs(d):
     import glob
     cfgloc = d.getVar("KERNEL_CFG_LOCATION", True).split(":")
     cfgs=""
     for loc in cfgloc:
         cfgs += " ".join(glob.glob(os.path.join(loc, "*.cfg"))) or ""
         cfgs += " "
     normalizedCfgs = ""
     for cfg in cfgs.split():
         normalizedCfgs += os.path.basename(cfg) + " "
     return normalizedCfgs

KERNEL_CFG_AVAILABLE := "${@getCfgs(d)}"

# Adds "file://" string to each entries of KERNEL_CFG_FILES
def appendKernelCfgFiles(d):
    cfgfiles = d.getVar("KERNEL_CFG_FILES", True).split()
    appendedcfgfiles = ""
    for iter in cfgfiles:
        appendedcfgfiles += "file://" + iter + " "
    return appendedcfgfiles

PERLLIBDIRS_class-target = "${libdir}/perl"
PERLLIBDIRS_class-native = "${libdir}/perl-native"

