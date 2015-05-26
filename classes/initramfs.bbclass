
python () {
    if bb.data.inherits_class('image', d) :
      image = bb.data.getVar("PN",d,True)
      initramfsImage = bb.data.getVar("INITRAMFS_IMAGE", d, True)
      if ( image == initramfsImage ):
         types = bb.data.getVar("IMAGE_FSTYPES",d, True)
         imagefeatures = bb.data.getVar("IMAGE_FEATURES", d, True)
         if ("cpio.gz" not in set(types.split())):
            types += " cpio.gz "
            bb.data.setVar("IMAGE_FSTYPES", types, d)
         if ("package-management" in set(imagefeatures.split())):
            imagefeatures = " ".join(set(imagefeatures.split()) - set(["package-management"]))
            bb.data.setVar("IMAGE_FEATURES", imagefeatures, d )
      elif initramfsImage :
         d.appendVarFlag('do_rootfs', 'depends', ' linux:do_initramfs') 
} 
