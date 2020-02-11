DESCRIPTION = "A disk partitioner/RAID/LVM configure tool."
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=59530bdf33659b29e73d4adb9f9f6552"
PR = "r3"

SRCREV="56cd22f5da88938227a9e2ea32f7118f4b3c51b7"
SRC_URI = "git://github.com/MontaVista-OpenSourceTechnology/uipartition.git;protocol=https"
S = "${WORKDIR}/git"
RDEPENDS_${PN} = "parted \
	          util-linux \
		  e2fsprogs-mke2fs \
		  file \
		  python3 \
		  python3-curses \
		  util-linux \
		  util-linux-fdisk \
                  util-linux-blkid \   
		  udev \
		  dosfstools \
		"

inherit distutils3

SRC_URI[md5sum] = "052a967fa9c523f817564a390b6d7da6"
SRC_URI[sha256sum] = "e246de0dfa5d27e93a131a51b7adfaf9f94e39f1af4e55a6aa5085824ccd2205"
