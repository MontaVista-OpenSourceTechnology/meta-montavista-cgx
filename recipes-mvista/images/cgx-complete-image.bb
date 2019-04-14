
require devel-image.bb
export IMAGE_BASENAME = "cgx-complete-image"

PROFILE_PKGS = "${@getprofiles(d)}"

def getprofiles(d):
    profiles = d.getVar("CGX_PROFILES", True)
    multilibs = d.getVar("MULTILIB_VARIANTS", True)
    pkgs = ""
    for profile in profiles.split():
        pkgs = pkgs + " packagegroup-profile-" + profile
        if multilibs != "":
           for multilib in multilibs.split():
               pkgs = pkgs + " " + multilib + "-packagegroup-profile-" + profile
    return pkgs

IMAGE_INSTALL += "${PROFILE_PKGS}"

#FIXME: For some reason mkfs chokes on the yumdb
ROOTFS_POSTPROCESS_COMMAND += "remove_yum_dir;"

IMAGE_FSTYPES_remove = "cpio"
IMAGE_FSTYPES_remove = "cpio.gz"
IMAGE_FSTYPES_remove = "cpio.gz.u-boot"

MKUBIFS_ARGS="-F -m 2048 -e 126976 -c 12000"

remove_yum_dir () {
	rm -rf ${IMAGE_ROOTFS}/var/lib/dnf/yumdb/
}

TOOLCHAIN_TARGET_TASK_remove = "target-sdk-provides-dummy"    
