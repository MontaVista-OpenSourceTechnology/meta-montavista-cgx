LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PV = "${DISTRO_VERSION}"

INHIBIT_DEFAULT_DEPS = "1"
PACKAGES = "${PN}"

export METADATA_REVISION
export METADATA_BRANCH
do_install() {
	mkdir -p ${D}${sysconfdir}
	echo "${DISTRO_NAME} ${DISTRO_VERSION}" > ${D}${sysconfdir}/mvl-version
}
