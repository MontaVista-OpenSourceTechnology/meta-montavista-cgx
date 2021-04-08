python package_name_hook () {
    pass
}

DEBIANRDEP = "do_packagedata"
do_package_write_ipk[rdeptask] = "${DEBIANRDEP}"
do_package_write_deb[rdeptask] = "${DEBIANRDEP}"
do_package_write_tar[rdeptask] = "${DEBIANRDEP}"
do_package_write_rpm[rdeptask] = "${DEBIANRDEP}"

IMAGE_FEATURES[validitems] += "src-pkgs"
COMPLEMENTARY_GLOB[src-pkgs] = '*-src'

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
    if bb.data.inherits_class("image",d) :
          bb.build.addtask("do_populate_sdk", None, 'do_rootfs', d)    
# Add 10 to base abi priority to remove warnings in image creation when two abis have the same prioity
    if bb.data.inherits_class("update-alternatives",d):
          pnMult = d.getVar("PN", True)
          bpnMult = d.getVar("BPN", True)
          if (pnMult == bpnMult):
             prioMult = int(d.getVar("ALTERNATIVE_PRIORITY", True)) 
             prioMult += 5
             d.setVar("ALTERNATIVE_PRIORITY", prioMult)
}

SDKTARGETSYSROOT_mvista-cgx="${SDKPATH}/sysroots/${MACHINE}-montavista-linux"

P2BUILDDIR="${WORKDIR}/p2"
P2DIR="${DEPLOY_DIR}/p2/${SDK_ARCH}"
SDK_NAME = "${SDK_NAME_PREFIX}-${MACHINE}-${SDK_ARCH}"
MSD_VERSION ?="${DATETIME}"
PLUGIN_ID ?= "com.mvista.sdk.core-${MACHINE}-${SDK_ARCH}-mvlsdk"
FEATURE_ID ?= "com.mvista.sdk-${MACHINE}-${SDK_ARCH}-mvlsdk"
PLUGIN_NAME ?="MontaVista SDK ${MACHINE}-${SDK_ARCH}"
FEATURE_NAME ?="MontaVista SDK ${MACHINE}-${SDK_ARCH}"
VENDOR_NAME ?= "MontaVista Software, LLC."
ADK_VERSION ?= "${DISTRO_VERSION}"
MSD_REVISION ?= "${MSD_VERSION}"

OE_TERMINAL_EXPORTS += "MVL_SDK_PREFIX PATH"


#CORE_IMAGE_BASE_INSTALL_mvista-cgx = '\
#    ${@bb.utils.contains("IMAGE_FEATURES", "busyboxless", "packagegroup-core-boot-busyboxless", "packagegroup-core-boot", d)} \
#    packagegroup-base-extended \
#    ${CORE_IMAGE_EXTRA_INSTALL} \
#'


PRECONFIGURE_PREFIX ?= "KERNEL_"
do_kernel_postconfigure[vardeps] += "KERNEL_CONF_LIST"
do_kernel_postconfigure[doc] = "Adds kernel config values from the environment"
def get_kernel_config_env(d):
    preconfigure_prefix = d.getVar('PRECONFIGURE_PREFIX',True)
    prefix_len = len(preconfigure_prefix)
    startswith_var = preconfigure_prefix + 'CONFIG_'
    ignore_vars = { 'KERNEL_CONFIG_BUILD', 'KERNEL_CONFIG_COMMAND' }
    new_var = []
    for var in d.keys():
        if var.startswith(startswith_var) and var not in ignore_vars:
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
        ignore_vars = { 'KERNEL_CONFIG_BUILD', 'KERNEL_CONFIG_COMMAND' }
        new_vars = {}
        for var in d.keys():
            if var.startswith(startswith_var) and var not in ignore_vars:
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
   ${KERNEL_CONFIG_COMMAND}
}

do_make_scripts[depends] += "openssl-native:do_populate_sysroot"
do_make_scripts_mvista-cgx() {
        unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
        make CC="${KERNEL_CC}" LD="${KERNEL_LD}" AR="${KERNEL_AR}" \
                   -C ${STAGING_KERNEL_DIR} O=${STAGING_KERNEL_BUILDDIR} \
                   HOSTCC='gcc -I${STAGING_INCDIR_NATIVE} -L${STAGING_DIR_NATIVE}/usr/lib \
		   -Wl,-rpath,${STAGING_DIR_NATIVE}/usr/lib -L${STAGING_DIR_NATIVE}/lib \
		   -Wl,-rpath,${STAGING_DIR_NATIVE}/lib' \
                   scripts
}

# KERNEL_INTERNAL_CFG_LOCATION holds location of internal 
# kernel fragment files (.cfg files)
KERNEL_INTERNAL_CFG_LOCATION := "${@ d.getVar("MVLBASE",d,1)}/recipes-kernel/linux/cfg-files/"

# KERNEL_CFG_LOCATION contains internal kernel fragment files (.cfg files)
# EXTRA_CFG_DIRECTORY_LIST contains list of directories containing external 
# kernel fragment files (.cfg files). The list is delimited by colon (:).
EXTRA_KERNEL_CFG_DIRECTORY_LIST ?= ""
KERNEL_CFG_LOCATION := "${@ d.getVar("MVLBASE",d,1)}/recipes-kernel/linux/cfg-files/:${EXTRA_KERNEL_CFG_DIRECTORY_LIST}"

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

PACKAGE_PREPROCESS_FUNCS_prepend += " get_fileperms "
PACKAGEBUILDPKGD_append += " fixup_stripped_perms "
PACKAGEFILEPERMS = "${WORKDIR}/dir.perms ${WORKDIR}/file.perms"
PACKAGEFILEPERMS_DISABLE ?= "0"

get_fileperms () {
    find ${PKGD} -type d | xargs  stat -c "%n %a %u %g %i" | sed -e 's,${PKGD},,' > ${WORKDIR}/dir.perms
    find ${PKGD} -type f | xargs  stat -c "%n %a %u %g %i" | sed -e 's,${PKGD},,' > ${WORKDIR}/file.perms
}

python fixup_stripped_perms () {
    # Provide method for turning off this code from the metadata.
    disable = d.getVar("PACKAGEFILEPERMS_DISABLE", True)
    if disable == "1":
       return

    # If strip can load pseudo there is no reason to execute these fix ups.
    # This can be either because the host abi and the toolchain are the same or
    # pseudo was built with both abi libraries.
    strip = d.getVar("STRIP", True)
    cmd = strip + " --info 2>&1 > /dev/null"
    (retval, output) = oe.utils.getstatusoutput(cmd)
    if not output.startswith("ERROR: ld.so: object"): 
       return

    import shutil

    # Copy package directory to allocate inodes in the off chance the pseudo database has conflicts.
    dvar = d.getVar("PKGD", True)

    # If packages.old exists remove it.
    if os.path.isdir(dvar + ".old"):
       shutil.rmtree(dvar + ".old")

    # If packages.save exists remove it
    if os.path.isdir(dvar + ".save"):
       shutil.rmtree(dvar + ".save")

    # Copy packages to packages.save, move packages to packages.old and
    # packages.new to packages
    shutil.copytree(dvar, dvar + ".save", symlinks=True)
    shutil.move(dvar, dvar + ".old")
    shutil.move(dvar + ".save", dvar)

    check_uid = d.getVar('HOST_USER_UID', True)

    pkgfileperms = d.getVar("PACKAGEFILEPERMS", True)

    for iter in pkgfileperms.split():
        files = open(iter).read()
        import stat
        for file in files.split("\n"):
            fsplit = file.split(" ")
            if len(fsplit) != 5:
               continue 
            fname, mode, user, group, inode = fsplit
            tfile = dvar + "/" + fname
            if os.path.exists(tfile):
               filest = os.stat(tfile)

               # Fix mode if not correct from do_install
               if (stat.S_IMODE(filest.st_mode) != int(mode,8)):
                  os.chmod(tfile, int(mode,8))

               # Fix owner/group if not correct from do_install
               if (filest.st_uid != 0) or (filest.st_uid != user) or (filest.st_gid != group):
                  if (filest.st_uid == int(check_uid)) or (user == check_uid):
                     setuid = 0
                     setgid = 0
                  else:
                     setuid = int(user)
                     setgid = int(group)
                  os.chown(tfile, setuid, setgid)
               
               # If the debug file is found, make sure it is owned by root. 
               dtfile = "%s" % os.path.dirname(tfile) + "/.debug/" + os.path.basename(tfile)
               if os.path.exists(dtfile):
                  bb.note("found: %s" % dtfile)
                  os.chown(dtfile, 0, 0)

}

# Code not to remove debug symbols from kernel module for AArch64
python () {
    if bb.data.inherits_class("module",d) or bb.data.inherits_class("module-base",d):
        if bb.utils.contains('TUNE_FEATURES', 'aarch64', True, False, d):
            d.setVar('INHIBIT_PACKAGE_STRIP', '1')
}

kernel_do_install_append_pn-linux-mvista () {
     mkdir -p ${D}/usr/src/
     cp ${B}/.config ${STAGING_KERNEL_DIR}/
     tar -C ${STAGING_KERNEL_DIR}  --exclude='.git' -czvf ${D}/usr/src/linux.tar.gz .
     rm ${STAGING_KERNEL_DIR}/.config
}

kernel_do_deploy_append () {
    if [ "${KERNEL_IMAGETYPE}" != "vmlinux" ]; then
        if [ -e vmlinux ] ; then
            BASE_NAME=$(echo "${KERNEL_IMAGE_NAME}" | cut -d - -f 2-)
            BASE_SYMLINK_NAME=$(echo "${KERNEL_IMAGE_LINK_NAME}" | cut -d - -f 2-)

            install -m 0644 vmlinux ${DEPLOYDIR}/vmlinux-$BASE_NAME.bin

            # Make sure image symbolic links always point to latest image built.
            rm -f ${DEPLOYDIR}/vmlinux-$BASE_SYMLINK_NAME.bin
            rm -f ${DEPLOYDIR}/vmlinux
            ln -sf vmlinux-$BASE_NAME.bin ${DEPLOYDIR}/vmlinux-$BASE_SYMLINK_NAME.bin
            ln -sf vmlinux-$BASE_NAME.bin ${DEPLOYDIR}/vmlinux
       fi
    fi

    # Make sure image symbolic links always point to latest image built.
    for type in ${KERNEL_IMAGETYPES} ; do
            if [ "${type}" != "vmlinux" -a "${type}" != "Image" ] ; then
		base_name=${type}-${KERNEL_IMAGE_NAME}
		symlink_name=${type}-${KERNEL_IMAGE_LINK_NAME}
		ln -sf ${base_name}.bin ${DEPLOYDIR}/${symlink_name}.bin
		ln -sf ${base_name}.bin ${DEPLOYDIR}/${type}
            fi
    done
}

PACKAGES_append_pn-linux-mvista += "kernel-src"
FILES_kernel-src_pn-linux-mvista = "/usr/src/linux.tar.gz"

prep_copy_buildsystem () {
    mkdir -p ${SDK_OUTPUT}/${SDKPATH}/conf
    mkdir -p ${SDK_OUTPUT}/${SDKPATH}/sources
    set -x 
    if [ -e "${TOPDIR}/conf/local-content.conf" ] ; then
       cp ${TOPDIR}/conf/local-content.conf ${SDK_OUTPUT}/${SDKPATH}/conf
       cat ${TOPDIR}/conf/local-content.conf | grep '^MV.*_TREE =' | sed -e 's,",,g' | sed -e "s,',,g"| while read META EQ TREE; do
           if [ -d $(echo $TREE | sed s,git://,,) ] ; then
              cp -a $(echo $TREE | sed s,git://,,) ${SDK_OUTPUT}/${SDKPATH}/sources
              sed -i ${SDK_OUTPUT}/${SDKPATH}/conf/local-content.conf -e "s,$TREE,git://\$\{TOPDIR\}/sources/$(basename $TREE),"
           fi
       done
    fi
}

python copy_buildsystem_prepend_mvista-cgx () {
    bb.build.exec_func("prep_copy_buildsystem", d)
}
