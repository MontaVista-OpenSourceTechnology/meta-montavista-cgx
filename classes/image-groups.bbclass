python () {
   if bb.data.inherits_class('image',d):
      extend=d.getVar("BBCLASSEXTEND",True) or ""
      pn=d.getVar("PN",True)
      imagegroupextra="packagegroup-image:base"
      imagegroupdepends=" packagegroup-" + pn
      for ext in extend.split():
         if ext.startswith("multilib:"):
              imagegroupextra += " packagegroup-image:" + ext.replace("multilib:","")
      d.setVar("BBCLASSEXTEND", "%s %s" % (imagegroupextra, extend))
      if not pn.startswith("packagegroup-"):
         depends=d.getVar("DEPENDS",True)
         d.setVar("DEPENDS", depends + imagegroupdepends)
       
}

do_deploy_packagedata () {
        :
}

DEPLOY_PACKAGEDATA = "${TMPDIR}/deploy/pkgdata"
do_deploy_packagedata[sstate-inputdirs] = "${PKGDESTWORK}"
do_deploy_packagedata[sstate-outputdirs] = "${DEPLOY_PACKAGEDATA}"
do_deploy_packagedata[sstate-lockfile-shared] = "${PACKAGELOCK}"
do_deploy_packagedata[stamp-extra-info] = "${MACHINE}"

python do_deploy_packagedata_setscene () {
        sstate_setscene(d)
}

python () {
    if not ( bb.data.inherits_class('image', d) or bb.data.inherits_class('native', d) or bb.data.inherits_class('nativesdk', d)):
        if d.getVarFlag('do_packagedata', 'noexec', True) != '1':
            bb.build.addtask('do_deploy_packagedata', 'do_build', 'do_packagedata', d)
            bb.build.addtask('do_deploy_packagedata_setscene', None, None, d)
            sstatetasks = d.getVar('SSTATETASKS', True) or ""
            d.setVar('SSTATETASKS', sstatetasks + " do_deploy_packagedata")
    elif bb.data.inherits_class('packagegroup-image', d):
        bb.build.addtask('do_deploy_packagedata', 'do_package_write_rpm', 'do_packagedata', d)
        bb.build.addtask('do_deploy_packagedata_setscene', None, None, d)
        sstatetasks = d.getVar('SSTATETASKS', True) or ""
        d.setVar('SSTATETASKS', sstatetasks + " do_deploy_packagedata")
}
