SUMMARY = "Sanitized set of kernel headers for the C library's use"
SECTION = "devel"
LICENSE = "GPLv2"

#########################################################################
####                        PLEASE READ 
#########################################################################
#
# You're probably looking here thinking you need to create some new copy
# of linux-libc-headers since you have your own custom kernel. To put 
# this simply, you DO NOT.
#
# Why? These headers are used to build the libc. If you customise the 
# headers you are customising the libc and the libc becomes machine
# specific. Most people do not add custom libc extensions to the kernel
# and have a machine specific libc.
#
# But you have some kernel headers you need for some driver? That is fine
# but get them from STAGING_KERNEL_DIR where the kernel installs itself.
# This will make the package using them machine specific but this is much
# better than having a machine specific C library. This does mean your 
# recipe needs a DEPENDS += "virtual/kernel" but again, that is fine and
# makes total sense.
#
# There can also be a case where your kernel extremely old and you want
# an older libc ABI for that old kernel. The headers installed by this
# recipe should still be a standard mainline kernel, not your own custom 
# one.
#
# -- RP

LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

python __anonymous () {
    major = d.getVar("PV",True).split('.')[0]
    if major == "3":
        d.setVar("HEADER_FETCH_VER", "3.0")
    else:
        d.setVar("HEADER_FETCH_VER", "2.6")
    sourcedir = d.getVar("MV_KERNEL_TREE", True)
    if sourcedir:
       if sourcedir.startswith("file://") and not os.path.isdir(sourcedir.replace("file://","")):
          raise bb.parse.SkipPackage("")
    else:
          raise bb.parse.SkipPackage("")
    tree = d.getVar("MV_KERNEL_TREE", True)
    if not (tree.startswith("git:///") and os.path.isdir(tree.replace("git://",""))):
       d.setVar("SRC_URI", 
        "${KERNELORG_MIRROR}/linux/kernel/v${HEADER_FETCH_VER}/linux-${PV}.tar.${KORG_ARCHIVE_COMPRESSION}")
     
}

inherit kernel-arch

MV_KERNEL_TREE_BRANCH ?= "mvl-4.9/msd.cgx"
MV_KERNEL_TREE_SRCREV ?= "${AUTOREV}"
MV_KERNEL_TREE ?= "git://${TOPDIR}/sources/linux-mvista-2.2"

SRCREV="${MV_KERNEL_TREE_BRANCH}"
KORG_ARCHIVE_COMPRESSION ?= "bz2"
SRC_URI = "${MV_KERNEL_TREE};branch=${MV_KERNEL_TREE_BRANCH}"
S = "${WORKDIR}/git"
BB_GENERATE_MIRROR_TARBALLS = "0"

do_configure() {
	oe_runmake allnoconfig
}

do_compile () {
}

do_install() {
	oe_runmake headers_install INSTALL_HDR_PATH=${D}${exec_prefix}
	# Kernel should not be exporting this header
	rm -f ${D}${exec_prefix}/include/scsi/scsi.h

	# The ..install.cmd conflicts between various configure runs
	find ${D}${includedir} -name ..install.cmd | xargs rm -f
}

BBCLASSEXTEND = "nativesdk"

#DEPENDS = "cross-linkage"
RDEPENDS_${PN}-dev = ""
RRECOMMENDS_${PN}-dbg = "${PN}-dev (= ${EXTENDPKGV})"

INHIBIT_DEFAULT_DEPS = "1"
DEPENDS += "unifdef-native"