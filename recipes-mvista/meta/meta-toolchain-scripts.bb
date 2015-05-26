LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
ALLOW_EMPTY_${PN} = "1"
PR = "r5"

inherit toolchain-scripts
FILES_${PN} = "${includedir}/sdk/"
python do_external_sdk_files() {
    pn = d.getVar('PN', True)
    runtime_mapping_rename("TOOLCHAIN_TARGET_TASK", pn, d)

    # Handle multilibs in the SDK environment, siteconfig, etc files...
    localdata = bb.data.createCopy(d)

    # make sure we only use the WORKDIR value from 'd', or it can change
    localdata.setVar('WORKDIR', d.getVar('WORKDIR', True))

    # make sure we only use the SDKTARGETSYSROOT value from 'd'
    localdata.setVar('SDKTARGETSYSROOT', d.getVar('SDKTARGETSYSROOT', True))

    # Process DEFAULTTUNE
    bb.build.exec_func("create_env_files", localdata)

    variants = d.getVar("MULTILIB_VARIANTS", True) or ""
    for item in variants.split():
        # Load overrides from 'd' to avoid having to reset the value...
        overrides = d.getVar("OVERRIDES", False) + ":virtclass-multilib-" + item
        localdata.setVar("OVERRIDES", overrides)
        bb.data.update_data(localdata)
        bb.build.exec_func("create_env_files", localdata)

}
create_env_files() {
        mkdir -p ${WORKDIR}/sdk
	# Setup site file for external use
	toolchain_create_sdk_siteconfig ${WORKDIR}/sdk/site-config-${REAL_MULTIMACH_TARGET_SYS}

	toolchain_create_sdk_env_script ${WORKDIR}/sdk/environment-setup-${REAL_MULTIMACH_TARGET_SYS}

	# Add version information
	toolchain_create_sdk_version ${WORKDIR}/sdk/version-${REAL_MULTIMACH_TARGET_SYS}

}
do_install () {
        install -d ${D}${includedir}/mv-sdk/
	install ${WORKDIR}/sdk/* ${D}${includedir}/mv-sdk/
}


addtask external_sdk_files before do_install
