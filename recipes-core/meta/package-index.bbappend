python () {
    # The following code should be kept in sync w/ the populate_sdk_rpm version.

    # package_arch order is reversed.  This ensures the -best- match is listed first!
    package_archs = d.getVar("PACKAGE_ARCHS", True) or ""
    package_archs = ":".join(package_archs.split()[::-1])
    package_os = d.getVar("TARGET_OS", True) or ""
    ml_prefix_list = "%s:%s" % ('default', package_archs)
    ml_os_list = "%s:%s" % ('default', package_os)
    multilibs = d.getVar('MULTILIBS', True) or ""
    for ext in multilibs.split():
        eext = ext.split(':')
        if len(eext) > 1 and eext[0] == 'multilib':
            localdata = bb.data.createCopy(d)
            default_tune = localdata.getVar("DEFAULTTUNE_virtclass-multilib-" + eext[1], False)
            if default_tune:
                localdata.setVar("DEFAULTTUNE", default_tune)
                bb.data.update_data(localdata)
            package_archs = localdata.getVar("PACKAGE_ARCHS", True) or ""
            package_archs = ":".join([i in "all noarch any".split() and i or eext[1]+"_"+i for i in package_archs.split()][::-1])
            package_os = localdata.getVar("TARGET_OS", True) or ""
            ml_prefix_list += " %s:%s" % (eext[1], package_archs)
            ml_os_list += " %s:%s" % (eext[1], package_os)
    d.setVar('MULTILIB_PREFIX_LIST', ml_prefix_list)
    d.setVar('MULTILIB_OS_LIST', ml_os_list)
}
addtask package_update_index_rpm before do_build after do_package_index
do_package_update_index_rpm () {

createrepo -q ${DEPLOY_DIR_RPM}
}
