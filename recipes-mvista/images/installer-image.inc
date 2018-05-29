
INC_PR = "r1"

inherit syslinux

syslinux_populate_prepend () {
    # install -m 0755 ${S}/boot/bzImage ${S}/boot/bzImage  
     touch  ${S}/syslinux.cfg    
     cat >> ${S}/syslinux.cfg << EOF
serial 0 115200
say This is boot text
display bootmsg.txt
prompt 1
timeout 15
default vga
label vga
  kernel vmlinuz
  append root=/dev/sr0 ip=off ro rootdelay=15
label serial
  kernel vmlinuz
  append root=/dev/sr0 ip=off ro rootdelay=15 console=ttyS0,115200n81
EOF
}

inherit image image-live 
#inherit image mv_bootimg

build_iso() {
 if [ -z "${RFS}" ]; then
 bbnote "Root File System path not defined."
 return
 fi
 install -d ${ISODIR}
 if [ -z "${ISODIR}" ]; then
 bbnote "Root File System path not defined."
 return
 fi

 install -m 0644 ${WORKDIR}/rootfs/boot/bzImage-* ${ISODIR}/vmlinuz
 cp -a ${RFS}/* ${ISODIR}


 bbnote "Syslinux ISO images are untested, please provide feedback."
 syslinux_iso_populate ${ISODIR}
 mkisofs -V ${BOOTIMG_VOLUME_ID} \
 -o ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.iso \
 -b ${ISO_BOOTIMG} -c ${ISO_BOOTCAT} -r \
 ${MKISOFS_OPTIONS} ${ISODIR}

 # mkisofs -V ${BOOTIMG_VOLUME_ID} \
 # -o ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.iso \
 # -r ${ISODIR}

 isohybrid ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.iso
 cd ${DEPLOY_DIR_IMAGE}
 rm -f ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.iso
 ln -s ${IMAGE_NAME}.iso ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.iso
}






