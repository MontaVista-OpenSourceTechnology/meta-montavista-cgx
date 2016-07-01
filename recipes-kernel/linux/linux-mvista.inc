
DEPENDS += "meta-toolchain-scripts"

PACKAGES =+ "kernel-src kernel-map"
FILES_kernel-src = "/usr/src/linux.tar.gz"
FILES_kernel-map = "/boot/System.map-* /boot/config-* /boot/kenv.sh /boot/sdk"
RDEPENDS_kernel-dev += "kernel-map"
RDEPENDS_kernel-modules += "kernel-map kmod"
RDEPENDS_kernel-image += "kernel-map"
RDEPENDS_kernel += "kernel-image"
FILES_kernel-image += "/boot/vmlinuz-*"
BB_GENERATE_MIRROR_TARBALLS = "0"

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

DEVSHELL_STARTDIR = "${B}"
do_devshell[depends] += "${PN}:do_kernel_postconfigure"

def fix_up_pkgconfig (d):
    d.setVar("PKG_CONFIG_DIR", "%s/%s/pkgconfig" % (d.getVar("STAGING_DIR_NATIVE", True), d.getVar("libdir_native", True)))
    oeterm_exports = d.getVar("OE_TERMINAL_EXPORTS", True)
    oeterm_exports += " PKG_CONFIG_DIR PKG_CONFIG_PATH PKG_CONFIG_LIBDIR PKG_CONFIG_SYSROOT_DIR " 
    oeterm_exports += " KERNEL_CC KERNEL_LD KENREL_AR KERNEL_EXTRA_ARGS KERNEL_IMAGETYPE CROSS_COMPILE" 
    d.setVar("OE_TERMINAL_EXPORTS", oeterm_exports)

python do_devshell_prepend () {
    d.delVarFlag("do_devshell", "manualfakeroot")
    fix_up_pkgconfig (d)
}
python do_menuconfig_prepend () {
    fix_up_pkgconfig (d)
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
        echo 'export TARGET_ARCH="${TARGET_ARCH}"' >> $kvnsh
        echo 'export CROSS_COMPILE="${TARGET_PREFIX}"' >> $kvnsh
        echo 'export KERNEL_CC="${KERNEL_CC}"' >> $kvnsh
        echo 'export KERNEL_LD="${KERNEL_LD}"' >> $kvnsh
        echo 'export KERNEL_AR="${KERNEL_AR}"' >> $kvnsh
        echo 'export OBJCOPY="${@os.path.basename(d.getVar('OBJCOPY',1))} "' >> $kvnsh
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

kernel_do_deploy_append () {
    if [ "${KERNEL_IMAGETYPE}" != "vmlinux" ]; then
        if [ -e vmlinux ] ; then

            BASE_NAME=$(echo "${KERNEL_IMAGE_BASE_NAME}" | cut -d - -f 2-)
            BASE_SYMLINK_NAME=$(echo "${KERNEL_IMAGE_SYMLINK_NAME}" | cut -d - -f 2-)

            install -m 0644 vmlinux ${DEPLOYDIR}/vmlinux-$BASE_NAME.bin

            # Make sure image symbolic links always point to latest image built.
            rm -f ${DEPLOYDIR}/vmlinux-$BASE_SYMLINK_NAME.bin
	    rm -f ${DEPLOYDIR}/vmlinux
            ln -sf vmlinux-$BASE_NAME.bin \
	    ${DEPLOYDIR}/vmlinux-$BASE_SYMLINK_NAME.bin
            ln -sf vmlinux-$BASE_NAME.bin ${DEPLOYDIR}/vmlinux
	fi
    fi	

    # Make sure image symbolic links always point to latest image built.
    rm -f ${DEPLOYDIR}/${KERNEL_IMAGE_SYMLINK_NAME}.bin
    rm -f ${DEPLOYDIR}/${KERNEL_IMAGETYPE}

    ln -sf ${KERNEL_IMAGE_BASE_NAME}.bin ${DEPLOYDIR}/${KERNEL_IMAGE_SYMLINK_NAME}.bin
    ln -sf ${KERNEL_IMAGE_BASE_NAME}.bin ${DEPLOYDIR}/${KERNEL_IMAGETYPE}
}
