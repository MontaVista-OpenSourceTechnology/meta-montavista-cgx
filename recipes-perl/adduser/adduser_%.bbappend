SRC_URI = " https://salsa.debian.org/debian/${BPN}/-/archive/debian/${PV}/${BPN}-debian-${PV}.tar.gz \
           file://adduser-add-M-option-for-useradd.patch \
"
SRC_URI[md5sum] = "851de0d4a7688264a39bc0ae54c4819e"
SRC_URI[sha256sum] = "970ec061485232781f4f46c98b862768bf01d05fb160e2696d3c21721c325ece"

S = "${WORKDIR}/${BPN}-debian-${PV}"
