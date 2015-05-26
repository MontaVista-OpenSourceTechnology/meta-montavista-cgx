python () {
    deps = bb.data.getVarFlag('do_rootfs', 'depends', d) or ""
    for partition in d.getVar("PARTITIONS", True).split():
        filesystems = d.getVar("PARTITION_%s_FS" % partition, True) or ""
        for fs in filesystems.split():
            for dep in (d.getVar("IMAGE_DEPENDS_%s" % fs, True) or "").split():
                deps += " %s:do_populate_sysroot" % dep
    for dep in (bb.data.getVar('EXTRA_IMAGEDEPENDS', d, True) or "").split():
        deps += " %s:do_populate_sysroot" % dep
    bb.data.setVarFlag('do_rootfs', 'depends', deps, d)
}

PARTITIONS ?= "base"
PARTITION_base_PATH = "/"
PARTITION_base_FS ?= "${IMAGE_FSTYPES}"
def get_splitcmds(d):
        cmds = []
        partitions = d.getVar("PARTITIONS", True) or ""
        for partition in partitions.split():
                if partition == "base":
                     continue
                cmds.append("rm -rf ${IMAGE_ROOTFS}-%s;" % partition)
                cmds.append("mv ${IMAGE_ROOTFS}/${PARTITION_%s_PATH} ${IMAGE_ROOTFS}-%s;" % (partition, partition))
                cmds.append("mkdir ${IMAGE_ROOTFS}/${PARTITION_%s_PATH};" % partition)
        return ' '.join(cmds)

def get_partitioncmds(d):
        cmds = []
        localdata = bb.data.createCopy(d)
        baserootfssize=localdata.getVar("IMAGE_ROOTFS_SIZE",True)
        rootfs=localdata.getVar("IMAGE_ROOTFS", True)
        imagename=localdata.getVar("IMAGE_NAME", True)
        imagenamelink=localdata.getVar("IMAGE_LINK_NAME", True)
        partitions = d.getVar("PARTITIONS", True) or ""
        for partition in partitions.split():
                rootfssize=baserootfssize
                partitionname = partition
                if partition == "base":
                        continue
                localdata.setVar("IMAGE_FSTYPES", localdata.getVar("PARTITION_%s_FS" % partition, True) or localdata.getVar("IMAGE_FSTYPES", True)) 
                localdata.setVar("IMAGE_ROOTFS", "%s-%s" % (rootfs,partition)) 
                localdata.setVar("IMAGE_NAME", "%s-%s" % (imagename,partition)) 
                localdata.setVar("IMAGE_LINK_NAME", "%s-%s" % (imagenamelink,partition))
                partsize=localdata.getVar("PARTITION_%s_SIZE" %  partition, True)
                if partsize:
                      rootfssize="${PARTITION_%s_SIZE}" % (partition)
                localdata.setVar("IMAGE_ROOTFS_SIZE", rootfssize)                
                localdata.setVar("IMAGE_LINK_NAME", "%s-%s" % (imagenamelink,partition))
                cmds += ["\trm -f ${DEPLOY_DIR_IMAGE}/%s-%s.*" % (imagenamelink,partition)]
                cmds += [get_imagecmds(localdata)]
        return ' \n '.join(cmds)

def get_update_fstab_cmds(d):
        cmds = []
        for partition in d.getVar("PARTITIONS", True).split():
                if partition == "base":
                   continue
                cmds.append("add_update_fstab '%s' '%s' '%s'" % ((d.getVar("PARTITION_%s_FS" % partition, True) or "").split()[0], d.getVar("PARTITION_%s_PATH" % partition, True), d.getVar("PARTITION_%s_DEVICE" % partition, True) or ""))
        return '\n'.join(cmds)

munge_fstype_fstab () {
	if [ -f ${IMAGE_ROOTFS}${sysconfdir}/fstab ]; then
		sed -i s/ext2\.gz/ext2/g  ${IMAGE_ROOTFS}${sysconfdir}/fstab
		sed -i s/ext3\.gz/ext3/g  ${IMAGE_ROOTFS}${sysconfdir}/fstab
	fi
}

add_update_fstab () {
	if [ -z "$3" ]; then
		_device="/dev/FIXME"
	else
		_device="$3"
	fi

	found=
	cat ${IMAGE_ROOTFS}${sysconfdir}/fstab | while read device mount fs opts dump pass; do
		if [ "$mount" = "$2" ]; then
			found=1
			echo "$device $mount $1 $opts $dump $pass"
		else
			echo "$device $mount $fs $opts $dump $pass"
		fi
	done > ${IMAGE_ROOTFS}${sysconfdir}/fstab.new
	if [ -z "$found" ]; then
		echo "$_device $2 $1 defaults 0 0" >> ${IMAGE_ROOTFS}${sysconfdir}/fstab.new
	fi
	mv ${IMAGE_ROOTFS}${sysconfdir}/fstab.new ${IMAGE_ROOTFS}${sysconfdir}/fstab
}

split_partitions () {
        ${@get_splitcmds(d)}
        ${@get_partitioncmds(d)}
        ${@get_update_fstab_cmds(d)}
        munge_fstype_fstab
}
IMAGE_PREPROCESS_COMMAND_append ="split_partitions;"
