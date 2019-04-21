PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

SUMMARY ="Image Package Group for ${PN}"
SUMMARY_${PN}-dbg ="Image Package Group for ${PN}"
SUMMARY_${PN}-dev ="Image Package Group for ${PN}"
DESCRIPTION_${PN}-dbg="Image Package Group for ${PN}"
DESCRIPTION_${PN}-dev="Image Package Group for ${PN}"
RDEPENDS_${PN} := "${RDEPENDS}"
RDEPENDS=""
IMAGE_TYPES="ext2"
IMAGE_GEN_DEBUGFS="0"
do_rootfs[noexec] = "1"
do_deploy[noexec] = "1"
do_image[noexec] = "1"
do_image_wic[noexec] = "1"
do_rootfs_wicenv[noexec] = "1"
do_bootimg[noexec] = "1"
do_bootimg[depends] = ""
do_image_ext2[noexec] = "1"
do_bootdirectdisk[depends] = ""
do_bootdirectdisk[noexec] = "1"
do_write_qemuboot_conf[depends] = ""
do_write_qemuboot_conf[noexec] = "1"
do_image_complete[depends] = ""
do_image_complete[noexec] = "1"
do_prepare_recipe_sysroot[depends] = ""
do_prepare_recipe_sysroot[noexec] = "1"
do_populate_lic_deploy[depends] = ""
do_populate_lic_deploy[noexec] = "1"
do_image_qa[depends] = ""
do_image_qa[noexec] = "1"

IMAGE_FSTYPES=""
PACKAGES="${PN}"
RRECOMMENDS_${PN} := "${RRECOMMENDS}"
RRECOMMENDS = ""
SRC_URI=""

python multilib_virtclass_handler_append() {
    if bb.data.inherits_class('packagegroup-image', e.data):
       e.data.setVar("MLPREFIX", variant + "-")
       override = ":virtclass-multilib-" + variant
       e.data.setVar("PN", variant + "-packagegroup-" + e.data.getVar("PN", True).replace("-packagegroup-image", "")))
}
python packagegroupimage_virtclass_handler () {
    if not isinstance(e, bb.event.RecipePreFinalise):
        return

    pn = e.data.getVar("PN", True)
    classextend = e.data.getVar('BBEXTENDCURR', True) or ""
    classextendvar = e.data.getVar('BBEXTENDVARIANT', True) or ""
    mlprefix = e.data.getVar('MLPREFIX', True) or ""
    if "packagegroup-image" not in classextend:
        return
    if classextendvar != "base":
       raw_pn = classextendvar + "-packagegroup-" + pn.replace("-packagegroup-image", "")
       e.data.setVar("RAW_PN", raw_pn)
       pn=classextendvar + "-" + pn
    e.data.setVar("PN", "packagegroup-" + pn.replace("-packagegroup-image", ""))
    e.data.setVar("OVERRIDES", e.data.getVar("OVERRIDES", False) + ":virtclass-packagegroup")
}

addtask do_package before do_build

python () {
    d.delVarFlag("do_package_write_rpm", "noexec")
    d.delVarFlag("do_package", "noexec")
    d.delVarFlag("do_packagedata", "noexec")
    d.delVarFlag("do_build", "noexec")
    variant = d.getVar("BBEXTENDVARIANT", True)
    extend =  d.getVar("BBEXTENDCURR",True)
    if extend == "packagegroup-image" and variant != "base":
       import oe.classextend

       clsextend = oe.classextend.ClassExtender(variant, d)
       
       clsextend.map_packagevars()
       pkgarch = d.getVar("PACKAGE_ARCH", False)
       d.setVar("PACKAGE_ARCH",variant + "_" + pkgarch)
       pn = d.getVar("PN", True)
       rprovides = variant + "-" + pn
       rprovides += " " + d.getVar("RAW_PN", True)
       d.setVar("RPROVIDES_%s" % pn, rprovides)
    bpn = d.getVar("BPN", True)
    skips=d.getVar("SKIP_IMAGES", True) or ""
    if bpn.replace("packagegroup-","").replace(variant + "-" , "") in set(skips.split()):
        raise bb.parse.SkipPackage("No need for this image.")
}
SSTATETASKS_remove = "do_image_complete do_image_qa do_populate_sdk_ext do_populate_sdk"
python do_write_qemuboot_conf () {
    return 
}
addhandler packagegroupimage_virtclass_handler

EXCLUDE_FROM_WORLD = ""
SKIP_IMAGES="core-image-minimal-initramfs build-appliance-image core-image-rt-sdk core-image-rt"
