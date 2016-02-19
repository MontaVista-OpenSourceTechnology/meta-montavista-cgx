DESCRIPTION = "A disk partitioner/RAID/LVM configure tool."
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=59530bdf33659b29e73d4adb9f9f6552"
PR = "r3"

SRC_URI = "${MVL_MIRROR}/mvpartition-${PV}.tar.gz \
	   file://mvpartition-ext-part-del-fix.patch;apply=yes \
	   file://reread-partitions-on-add.patch;apply=yes \
	   file://mvpartition-fix-fstab.patch;apply=yes \
	   file://fix-strip-err-on-num-conv.patch;apply=yes \
	   file://fix-raid-scan.patch;apply=yes \
	   file://fix-raid-partition-creation.patch;apply=yes \
	   file://add-vfat-support.patch;apply=yes \
	   file://add-old-ide-support.patch;apply=yes \
	   file://mvpartition-fix-scsi_id-cmd.patch;apply=yes \
	   file://mvpartition-change-xfs-string-touppercase.patch;apply=yes \
"

RDEPENDS_${PN} = "parted \
	          util-linux \
		  e2fsprogs-mke2fs \
		  file \
		  python \
		  python-curses \
		  python-subprocess \
		  util-linux \
		  util-linux-fdisk \
                  util-linux-blkid \   
		  udev \
		  dosfstools \
		"

inherit distutils

SRC_URI[md5sum] = "052a967fa9c523f817564a390b6d7da6"
SRC_URI[sha256sum] = "e246de0dfa5d27e93a131a51b7adfaf9f94e39f1af4e55a6aa5085824ccd2205"
