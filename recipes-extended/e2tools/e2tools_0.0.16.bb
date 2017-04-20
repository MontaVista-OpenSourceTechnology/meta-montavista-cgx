SRC_URI = " \
           http://home.earthlink.net/~k_sheff/sw/e2tools/e2tools-0.0.16.tar.gz \
           file://e2tools-no-poisoned-path.diff \
"

LICENSE = "GPL-2"
LIC_FILES_CHKSUM = "file://COPYING;md5=fa8321a71778d26ff40690a4d371ea85"

SRC_URI[md5sum] = "1829b2b261e0e0d07566066769b5b28b"
SRC_URI[sha256sum] = "4e3c8e17786ccc03fc9fb4145724edf332bb50e1b3c91b6f33e0e3a54861949b"

DEPENDS += "e2fsprogs"
inherit autotools

BBCLASSEXTEND = "native"
