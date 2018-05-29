FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS += "udev"

SRC_URI += " \
       file://55-scsi-sg3_id.rules \
       file://58-scsi-sg3_symlink.rules \
       "

PR .= ".1"

do_install_append() {
       install -d ${D}${base_libdir}/udev/rules.d/
       install -m 0644 ${WORKDIR}/55-scsi-sg3_id.rules ${D}${base_libdir}/udev/rules.d/
       install -m 0644 ${WORKDIR}/58-scsi-sg3_symlink.rules ${D}${base_libdir}/udev/rules.d/
}

PACKAGES =+ "${PN}-udev"
PROVIDES += "${PN}-udev"

FILES_${PN}-udev = "${base_libdir}/udev/rules.d/"
