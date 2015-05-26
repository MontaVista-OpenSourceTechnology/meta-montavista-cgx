require docbook-sgml-dtd-native.inc

LICENSE = "OASIS"
LIC_FILES_CHKSUM = "file://LICENSE-OASIS;md5=c608985dd5f7f215e669e7639a0b1d2e"

DTD_VERSION = "3.0"

PR = "${INC_PR}.0"

# Note: the upstream sources are not distributed with a license file.
# LICENSE-OASIS is included as a "patch" to workaround this. When
# upgrading this recipe, please verify whether this is still needed.
SRC_URI = "http://www.docbook.org/sgml/3.0/docbk30.zip \
           file://LICENSE-OASIS"

SRC_URI[md5sum] = "9a7f5b1b7dd52d0ca4fb080619f0459c"
SRC_URI[sha256sum] = "ecf71cbe8ddbad7494ff520d5b4edf73a428c0b159178cb0cb619cba685e61c6"

do_compile() {
    # Refer to http://www.linuxfromscratch.org/blfs/view/stable/pst/sgml-dtd-3.html
    # for details.
    sed -i -e '/ISO 8879/d' -e 's|DTDDECL "-//Davenport//DTD DocBook V3.0//EN"|SGMLDECL|g' docbook.cat
}
