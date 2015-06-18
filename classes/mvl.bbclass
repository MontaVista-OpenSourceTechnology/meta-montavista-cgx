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

python multilib_virtclass_handler_global_mvista-cgx () {
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

python multilib_virtclass_handler_mvista-cgx () {
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
	

OE_TERMINAL_EXPORTS += "MVL_SDK_PREFIX PATH"


CORE_IMAGE_BASE_INSTALL_mvista-cgx = '\
    ${@base_contains("IMAGE_FEATURES", "busyboxless", "packagegroup-core-boot-busyboxless", "packagegroup-core-boot", d)} \
    packagegroup-base-extended \
    ${CORE_IMAGE_EXTRA_INSTALL} \
'
