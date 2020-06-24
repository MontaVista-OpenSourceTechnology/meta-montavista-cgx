# installer CD image

DESCRIPTION = "Image for creating an install CD"
PR = "${INC_PR}.1"


#INSTALLED_IMAGE = "${PREPARED_IMAGE}"
INSTALLED_IMAGE = "default-image"

#Add the installed image to the root filesystem
IMAGE_PREPROCESS_COMMAND = "installer_image_preprocess"

installer_image_preprocess () {
        if [ "x${INSTALLER_TARBALL}" != "x" ]; then
                install -m 755 "${INSTALLER_TARBALL}" ${IMAGE_ROOTFS}/to_install.tar.gz
        elif [ "x${INSTALLED_IMAGE}" != "x" ]; then
                IIMAGE="${DEPLOY_DIR_IMAGE}/${INSTALLED_IMAGE}-${MACHINE}.tar.gz"
                install -m 755 "${IIMAGE}" ${IMAGE_ROOTFS}/to_install.tar.gz
        else
                touch ${IMAGE_ROOTFS}/to_install.tar.gz
        fi
}

# Make sure we build the kernel
#DEPENDS = "virtual/kernel"

#PACKAGE_GROUP_self-host-installer = "packagegroup-selfhost-installer"

#IMAGE_FEATURES += "self-host-installer"

IMAGE_INSTALL += "packagegroup-selfhost-installer packagegroup-selfhost-installer-defaultimage"

export IMAGE_BASENAME = "installer-image"
IMAGE_LINGUAS = ""

#NSTALLER_IMAGE_FSTYPES ??= "iso"
BOOTIMG_VOLUME_ID ??= "MVL TEST"


IMAGE_FSTYPES += " iso"
EXTRA_IMAGE_FEATURES += "debug-tweaks"

# No need for opkg stuff on the installer CD
ONLINE_PACKAGE_MANAGEMENT = "none"
LDCONFIGDEPEND = ""
NOHDD = "1"

EFI = "1"
RFS = "${WORKDIR}/rootfs"

require installer-image.inc

#do_rootfs[depends] +=${INSTALLER_IMAGE}
#do_roofs[depends] += "do_install_installerbinary"

#do_install_installerbinary()
#{
#	install -d -m  0755 ${WORKDIR}/rootfs/isolinux
#	install -m 0755 ${WORKDIR}/rootfs/boot/bzImage ${WORKDIR}/rootfs/isolinux/vmlinuz

#}

python () {
         dis =  d.getVar("LOCALEBASEPN", True)
         if dis == "packagegroup-lib32-installer-image" or dis == "packagegroup-installer-image" :
               d.setVarFlag('do_rootfs', 'noexec', '1')
               d.setVarFlag('do_bootimg', 'noexec', '1')
}


addtask install_installerbinary after do_rootfs before do_bootimg

do_bootimg[depends] += "${PN}:do_rootfs ${PN}:do_install_installerbinary"

python () {
      deps = (d.getVarFlag('do_bootimg', 'depends', True) or "").split()
      deps.remove(d.expand('${INITRD_IMAGE_LIVE}') + ':do_image_complete')
      d.setVarFlag('do_bootimg', 'depends', " ".join(deps))
}

#def remove_initrd_image_dependency(d):
#      localdata = d.createCopy()
#      task_depends = (localdata.getVarFlag('do_bootimg', 'depends') or "").split()
#      print "before: =====>"
#      print task_depends
#      print "after: =====>"
#      task_depends.remove('${INITRD_IMAGE}:do_rootfs')
#      print task_depends
#      return " "

do_install_installerbinary() {
    install -d -m  0755 ${WORKDIR}/rootfs/isolinux 
    install -m 0755 ${WORKDIR}/rootfs/boot/bzImage-* ${WORKDIR}/rootfs/isolinux/vmlinuz 
}

