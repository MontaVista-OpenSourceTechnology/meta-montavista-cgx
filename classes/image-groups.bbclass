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
       
      d.appendVarFlag('do_populate_sdk', 'depends', " " + pn + ":do_image_complete")
}
