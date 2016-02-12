require recipes-kernel/linux/linux-yocto.inc

MV_KERNEL_TREE_BRANCH ?= "mvl-4.1/cgx"
MV_KERNEL_TREE_SRCREV ?= "${AUTOREV}"
MV_KERNEL_TREE ?= "git://${TOPDIR}/sources/linux-mvista-4.1"

SRCREV_machine ?= "${MV_KERNEL_TREE_SRCREV}"
SRCREV ?= "${MV_KERNEL_TREE_SRCREV}"
SRCPV ?= "${MV_KERNEL_TREE_SRCREV}"
BRANCH ?= "${MV_KERNEL_TREE_BRANCH}"

SRC_URI = "${MV_KERNEL_TREE};branch=${BRANCH};name=machine"

PV = "${LINUX_VERSION}+git${SRCPV}"

KMETA = "meta"

DEPENDS += "meta-toolchain-scripts"

LINUX_KERNEL_TYPE = "standard"

LINUX_VERSION_EXTENSION ?= "-mvista"
KCONFIG_MODE = "--alldefconfig"

COMPATIBLE_MACHINE = "qemuarm|qemuarm64|qemux86|qemuppc|qemumips|qemumips64|qemux86-64"

PACKAGES =+ "kernel-src kernel-map"
FILES_kernel-src = "/usr/src/linux.tar.gz"
FILES_kernel-map = "/boot/System.map-* /boot/config-* /boot/kenv.sh /boot/sdk"
RDEPENDS_kernel-dev += "kernel-map"
RDEPENDS_kernel-modules += "kernel-map kmod"
RDEPENDS_kernel-image += "kernel-map"
RDEPENDS_kernel += "kernel-image"
FILES_kernel-image += "/boot/vmlinuz-*"

python __anonymous() {
    devicetree = d.getVar("KERNEL_DEVICETREE", True) or ''
    if devicetree:
        depends = d.getVar("RDEPENDS_kernel-image", True)
        d.setVar("RDEPENDS_kernel-image", "%s kernel-devicetree" % depends)
}

do_install_append () {
     if [ "${KERNEL_IMAGETYPE}" = "bzImage" ] ; then
       ln -s -f bzImage-${KERNEL_VERSION} ${D}/boot/vmlinuz-${KERNEL_VERSION}
     fi
     mkdir -p ${D}/usr/src/
     cp ${B}/.config ${STAGING_KERNEL_DIR}/
     tar -C ${STAGING_KERNEL_DIR}  --exclude='.git' -czvf ${D}/usr/src/linux.tar.gz .
     rm ${STAGING_KERNEL_DIR}/.config
}

do_install_prepend () {
        install -d ${STAGING_KERNEL_DIR}
        install -d ${D}/boot
        kvnsh=${STAGING_KERNEL_DIR}/kenv.sh
        kernel_arch="${TARGET_CC_KERNEL_ARCH}"
        if [ -z "$kernel_arch" ] ; then
            kernel_arch="${TARGET_CC_ARCH}"
        fi
        echo 'export ARCH="${@map_kernel_arch(d.getVar("TARGET_ARCH", 1), d)}"' > $kvnsh
        echo "export KCFLAGS=\"$kernel_arch\"" >> $kvnsh
        echo 'export CROSS_COMPILE="${TARGET_PREFIX}"' >> $kvnsh
        echo 'export KERNEL_CC="${KERNEL_CC}"' >> $kvnsh
        echo 'export KERNEL_LD="${KERNEL_LD}"' >> $kvnsh
        echo 'export KERNEL_AR="${KERNEL_AR}"' >> $kvnsh
        echo 'export KERNEL_IMAGETYPE="${KERNEL_IMAGETYPE}"' >> $kvnsh
        echo 'export KERNEL_OUTPUT="${KERNEL_OUTPUT}"' >> $kvnsh
        echo 'export KMACHINE="${MACHINE}"' >> $kvnsh
        echo 'export UBOOT_ENTRYPOINT="${UBOOT_ENTRYPOINT}"' >> $kvnsh
        echo 'export PN="${PN}"' >> $kvnsh
        echo 'export PV_BASE="${PV}"' >> $kvnsh
        echo 'export PR="${PR}"' >> $kvnsh
        echo 'export MSDVERSION="${MSD_VERSION}"' >> $kvnsh
        echo "export KERNEL_EXTRA_ARGS='${KERNEL_EXTRA_ARGS}'" >> $kvnsh
	echo 'export MVL_TOOL_DIR="${MVL_TOOL_DIR}"'
        echo "export TOOL_PREFIX=\"/tools/${MVL_TOOL_DIR}/bin:\"" >> $kvnsh
        cp ${STAGING_KERNEL_DIR}/kenv.sh ${D}/boot/ 
        install -d ${D}/boot/sdk
        install -d ${D}${KERNEL_SRC_PATH}/sdk
        if [ -d ${STAGING_DIR_TARGET}${includedir}/mv-sdk/ ] ; then
           cp ${STAGING_DIR_TARGET}${includedir}/mv-sdk/* ${D}/boot/sdk
           cp ${STAGING_DIR_TARGET}${includedir}/mv-sdk/* ${D}${KERNEL_SRC_PATH}/sdk
        elif [ -d sdk ] ; then
           cp sdk/* ${D}/boot/sdk
           cp sdk/* ${D}${KERNEL_SRC_PATH}/sdk
        fi
}

