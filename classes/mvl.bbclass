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
    toolchainflags = d.getVarFlag('TOOLCHAIN_OPTIONS', 'vardeps') or ""
    d.setVarFlag('TOOLCHAIN_OPTIONS', 'vardeps' , toolchainflags.replace('CSL_VER_MAIN',''))
}

python multilib_virtclass_handler_global_gen7 () {
    if not e.data:
        return

    if isinstance(e, bb.event.RecipePreFinalise):
        for v in e.data.getVar("MULTILIB_VARIANTS", True).split():
            if e.data.getVar("TARGET_VENDOR_virtclass-multilib-" + v, False) is None:
               e.data.setVar("TARGET_VENDOR_virtclass-multilib-" + v, e.data.getVar("TARGET_VENDOR", False) + "ml" + v)

    variant = e.data.getVar("BBEXTENDVARIANT", True)

    if isinstance(e, bb.event.RecipeParsed) and not variant:
        if bb.data.inherits_class('kernel', e.data) or \
            (bb.data.inherits_class('allarch', e.data) and\
             not bb.data.inherits_class('packagegroup', e.data)):
            variants = (e.data.getVar("MULTILIB_VARIANTS", True) or "").split()

            import oe.classextend
            clsextends = []
            for variant in variants:
                clsextends.append(oe.classextend.ClassExtender(variant, e.data))

            # Process PROVIDES
            origprovs = provs = e.data.getVar("PROVIDES", True) or ""
            for clsextend in clsextends:
                provs = provs + " " + clsextend.map_variable("PROVIDES", setvar=False)
            e.data.setVar("PROVIDES", provs)

            # Process RPROVIDES
            origrprovs = rprovs = e.data.getVar("RPROVIDES", True) or ""
            for clsextend in clsextends:
                rprovs = rprovs + " " + clsextend.map_variable("RPROVIDES", setvar=False)
            e.data.setVar("RPROVIDES", rprovs)

            # Process RPROVIDES_${PN}...
            for pkg in (e.data.getVar("PACKAGES", True) or "").split():
                origrprovs = rprovs = e.data.getVar("RPROVIDES_%s" % pkg, True) or ""
                for clsextend in clsextends:
                    rprovs = rprovs + " " + clsextend.map_variable("RPROVIDES_%s" % pkg, setvar=False)
                    rprovs = rprovs + " " + clsextend.extname + "-" + pkg
                e.data.setVar("RPROVIDES_%s" % pkg, rprovs)
}

python multilib_virtclass_handler_gen7 () {
    if not isinstance(e, bb.event.RecipePreFinalise):
        return

    cls = e.data.getVar("BBEXTENDCURR", True)
    variant = e.data.getVar("BBEXTENDVARIANT", True)
    if cls != "multilib" or not variant:
        return

    e.data.setVar('STAGING_KERNEL_DIR', e.data.getVar('STAGING_KERNEL_DIR', True))

    # There should only be one kernel in multilib configs
    # We also skip multilib setup for module packages.
    provides = (e.data.getVar("PROVIDES", True) or "").split()
    if "virtual/kernel" in provides:
        raise bb.parse.SkipPackage("We shouldn't have multilib variants for the kernel")

    save_var_name=e.data.getVar("MULTILIB_SAVE_VARNAME", True) or ""
    for name in save_var_name.split():
        val=e.data.getVar(name, True)
        if val:
            e.data.setVar(name + "_MULTILIB_ORIGINAL", val)

    if bb.data.inherits_class('image', e.data):
        e.data.setVar("MLPREFIX", variant + "-")
        e.data.setVar("PN", variant + "-" + e.data.getVar("PN", False))
        return

    if bb.data.inherits_class('cross-canadian', e.data):
        e.data.setVar("MLPREFIX", variant + "-")
        override = ":virtclass-multilib-" + variant
        e.data.setVar("OVERRIDES", e.data.getVar("OVERRIDES", False) + override)
        bb.data.update_data(e.data)
        return

    if bb.data.inherits_class('native', e.data):
        raise bb.parse.SkipPackage("We can't extend native recipes")

    if bb.data.inherits_class('nativesdk', e.data) or bb.data.inherits_class('crosssdk', e.data):
        raise bb.parse.SkipPackage("We can't extend nativesdk recipes")

    if bb.data.inherits_class('allarch', e.data) and not bb.data.inherits_class('packagegroup', e.data):
        raise bb.parse.SkipPackage("Don't extend allarch recipes which are not packagegroups")


    # Expand this since this won't work correctly once we set a multilib into place
    e.data.setVar("ALL_MULTILIB_PACKAGE_ARCHS", e.data.getVar("ALL_MULTILIB_PACKAGE_ARCHS", True))
 
    override = ":virtclass-multilib-" + variant

    e.data.setVar("MLPREFIX", variant + "-")
    e.data.setVar("PN", variant + "-" + e.data.getVar("PN", False))
    e.data.setVar("SHLIBSDIR_virtclass-multilib-" + variant ,e.data.getVar("SHLIBSDIR", False) + "/" + variant)
    e.data.setVar("OVERRIDES", e.data.getVar("OVERRIDES", False) + override)

    # DEFAULTTUNE can change TARGET_ARCH override so expand this now before update_data
    newtune = e.data.getVar("DEFAULTTUNE_" + "virtclass-multilib-" + variant, False)
    if newtune:
        e.data.setVar("DEFAULTTUNE", newtune)
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
ADK_VERSION ?= "7.1.2"
MSD_REVISION ?= "${MSD_VERSION}"
 
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
	
fakeroot create_shar_gen7() {
	cat << "EOF" > ${SDK_DEPLOY}/${TOOLCHAIN_OUTPUTNAME}.sh
#!/bin/bash

INST_ARCH=$(uname -m | sed -e "s/i[3-6]86/ix86/" -e "s/x86[-_]64/x86_64/")
SDK_ARCH=$(echo ${SDK_ARCH} | sed -e "s/i[3-6]86/ix86/" -e "s/x86[-_]64/x86_64/")

if [ "$INST_ARCH" != "$SDK_ARCH" ]; then
	# Allow for installation of ix86 SDK on x86_64 host
	if [ "$INST_ARCH" != x86_64 -o "$SDK_ARCH" != ix86 ]; then
		echo "Error: Installation machine not supported!"
		exit 1
	fi
fi

DEFAULT_INSTALL_DIR="${SDKPATH}"
SUDO_EXEC=""
target_sdk_dir=""
answer=""
relocate=1
savescripts=0
verbose=0
while getopts ":yd:DRS" OPT; do
	case $OPT in
	y)
		answer="Y"
		[ "$target_sdk_dir" = "" ] && target_sdk_dir=$DEFAULT_INSTALL_DIR
		;;
	d)
		target_sdk_dir=$OPTARG
		;;
	D)
		verbose=1
		;;
	R)
		relocate=0
		savescripts=1
		;;
	S)
		savescripts=1
		;;
	*)
		echo "Usage: $(basename $0) [-y] [-d <dir>]"
		echo "  -y         Automatic yes to all prompts"
		echo "  -d <dir>   Install the SDK to <dir>"
		echo "======== Advanced DEBUGGING ONLY OPTIONS ========"
		echo "  -S         Save relocation scripts"
		echo "  -R         Do not relocate executables"
		echo "  -D         use set -x to see what is going on"
		exit 1
		;;
	esac
done

if [ $verbose = 1 ] ; then
	set -x
fi

printf "Enter target directory for SDK (default: $DEFAULT_INSTALL_DIR): "
if [ "$target_sdk_dir" = "" ]; then
	read target_sdk_dir
	[ "$target_sdk_dir" = "" ] && target_sdk_dir=$DEFAULT_INSTALL_DIR
else
	echo "$target_sdk_dir"
fi

eval target_sdk_dir=$(echo "$target_sdk_dir"|sed 's/ /\\ /g')
if [ -d "$target_sdk_dir" ]; then
	target_sdk_dir=$(cd "$target_sdk_dir"; pwd)
else
	target_sdk_dir=$(readlink -m "$target_sdk_dir")
fi

if [ -n "$(echo $target_sdk_dir|grep ' ')" ]; then
	echo "The target directory path ($target_sdk_dir) contains spaces. Abort!"
	exit 1
fi

if [ -e "$target_sdk_dir/environment-setup-${REAL_MULTIMACH_TARGET_SYS}" ]; then
	echo "The directory \"$target_sdk_dir\" already contains a SDK for this architecture."
	printf "If you continue, existing files will be overwritten! Proceed[y/N]?"

	default_answer="n"
else
	printf "You are about to install the SDK to \"$target_sdk_dir\". Proceed[Y/n]?"

	default_answer="y"
fi

if [ "$answer" = "" ]; then
	read answer
	[ "$answer" = "" ] && answer="$default_answer"
else
	echo $answer
fi

if [ "$answer" != "Y" -a "$answer" != "y" ]; then
	echo "Installation aborted!"
	exit 1
fi

# Try to create the directory (this will not succeed if user doesn't have rights)
mkdir -p $target_sdk_dir >/dev/null 2>&1

# if don't have the right to access dir, gain by sudo 
if [ ! -x $target_sdk_dir -o ! -w $target_sdk_dir -o ! -r $target_sdk_dir ]; then 
	SUDO_EXEC=$(which "sudo")
	if [ -z $SUDO_EXEC ]; then
		echo "No command 'sudo' found, please install sudo first. Abort!"
		exit 1
	fi

	# test sudo could gain root right
	$SUDO_EXEC pwd >/dev/null 2>&1
	[ $? -ne 0 ] && echo "Sorry, you are not allowed to execute as root." && exit 1

	# now that we have sudo rights, create the directory
	$SUDO_EXEC mkdir -p $target_sdk_dir >/dev/null 2>&1
fi

payload_offset=$(($(grep -na -m1 "^MARKER:$" $0|cut -d':' -f1) + 1))

printf "Extracting SDK..."
tail -n +$payload_offset $0| $SUDO_EXEC tar xj -C $target_sdk_dir
echo "done"

printf "Setting it up..."
# fix environment paths
for env_setup_script in `ls $target_sdk_dir/environment-setup-*`; do
	$SUDO_EXEC sed -e "s:$DEFAULT_INSTALL_DIR:$target_sdk_dir:g" -i $env_setup_script
done

# fix dynamic loader paths in all ELF SDK binaries
native_sysroot=$($SUDO_EXEC cat $env_setup_script |grep OECORE_NATIVE_SYSROOT| grep -v SDK_PATH_NATIVE |cut -d'=' -f2|tr -d '"')
dl_path=$($SUDO_EXEC find $native_sysroot/lib -name "ld-linux*")
if [ "$dl_path" = "" ] ; then
	echo "SDK could not be set up. Relocate script unable to find ld-linux.so. Abort!"
	exit 1
fi
executable_files=$($SUDO_EXEC find $native_sysroot -type f -perm /111)

tdir=`mktemp -d`
if [ x$tdir = x ] ; then
   echo "SDK relocate failed, could not create a temporary directory"
   exit 1
fi
echo "#!/bin/bash" > $tdir/relocate_sdk.sh
echo exec ${env_setup_script%/*}/relocate_sdk.py $target_sdk_dir $dl_path $executable_files >> $tdir/relocate_sdk.sh
$SUDO_EXEC mv $tdir/relocate_sdk.sh ${env_setup_script%/*}/relocate_sdk.sh
$SUDO_EXEC chmod 755 ${env_setup_script%/*}/relocate_sdk.sh
rm -rf $tdir
if [ $relocate = 1 ] ; then
	$SUDO_EXEC ${env_setup_script%/*}/relocate_sdk.sh
	if [ $? -ne 0 ]; then
		echo "SDK could not be set up. Relocate script failed. Abort!"
		exit 1
	fi
fi

# replace ${SDKPATH} with the new prefix in all text files: configs/scripts/etc
$SUDO_EXEC find $native_sysroot -type f -exec file '{}' \;|grep ":.*\(ASCII\|script\|source\).*text"|cut -d':' -f1|$SUDO_EXEC xargs sed -i -e "s:$DEFAULT_INSTALL_DIR:$target_sdk_dir:g"

# change all symlinks pointing to ${SDKPATH}
for l in $($SUDO_EXEC find $native_sysroot -type l); do
	$SUDO_EXEC ln -sfn $(readlink $l|$SUDO_EXEC sed -e "s:$DEFAULT_INSTALL_DIR:$target_sdk_dir:") $l
done

# find out all perl scripts in $native_sysroot and modify them replacing the
# host perl with SDK perl.
for perl_script in $($SUDO_EXEC grep "^#!.*perl" -rl $native_sysroot 2>/dev/null); do
	$SUDO_EXEC sed -i -e "s:^#! */usr/bin/perl.*:#! /usr/bin/env perl:g" -e \
		"s: /usr/bin/perl: /usr/bin/env perl:g" $perl_script
done

echo done

# delete the relocating script, so that user is forced to re-run the installer
# if he/she wants another location for the sdk
if [ $savescripts = 0 ] ; then
	$SUDO_EXEC rm ${env_setup_script%/*}/relocate_sdk.py ${env_setup_script%/*}/relocate_sdk.sh
fi

echo "SDK has been successfully set up and is ready to be used."

exit 0

MARKER:
EOF
	# add execution permission
	chmod +x ${SDK_DEPLOY}/${TOOLCHAIN_OUTPUTNAME}.sh

	# append the SDK tarball
	cat ${SDK_DEPLOY}/${TOOLCHAIN_OUTPUTNAME}.tar.bz2 >> ${SDK_DEPLOY}/${TOOLCHAIN_OUTPUTNAME}.sh

	# delete the old tarball, we don't need it anymore
	rm ${SDK_DEPLOY}/${TOOLCHAIN_OUTPUTNAME}.tar.bz2
}

OE_TERMINAL_EXPORTS += "MVL_SDK_PREFIX PATH"


CORE_IMAGE_BASE_INSTALL_gen7 = '\
    ${@base_contains("IMAGE_FEATURES", "busyboxless", "packagegroup-core-boot-busyboxless", "packagegroup-core-boot", d)} \
    packagegroup-base-extended \
    ${CORE_IMAGE_EXTRA_INSTALL} \
'
