SUMMARY_${PN}-src ?= "${SUMMARY} - Contains pristine source tar after do_patch task"
DESCRIPTION_${PN}-src ?= "${DESCRIPTION}  \
This package contains pristine source at ${SRC_TAR_PATH} for package test purposes."

SRC_TAR_PATH ?= "${prefix}/src/${PN}-${PV}/"
FILES_${PN}-source = " ${SRC_TAR_PATH} "

SHIP_SOURCE_ENABLED = "1"
SHIP_SOURCE_ENABLED_class-native = ""
SHIP_SOURCE_ENABLED_class-nativesdk = ""
SHIP_SOURCE_ENABLED_class-cross-canadian = ""

PACKAGES =+ "${@bb.utils.contains('SHIP_SOURCE_ENABLED', '1', '${PN}-source', '', d)}"


do_tar_recipe_sources () {
    dir_to_be_compressed="$(basename ${S})"
    tar -cjf ${WORKDIR}/${BPN}-${PV}-patched.tar.bz2 -C ${WORKDIR} $dir_to_be_compressed
}

do_ship_recipe_sources () {
    install -D -m 0666 ${WORKDIR}/${BPN}-${PV}-patched.tar.bz2 ${D}${SRC_TAR_PATH}/${BPN}-${PV}-patched.tar.bz2
}

do_tar_recipe_sources[dirs] = "${WORKDIR}"
do_ship_recipe_sources[cleandirs] = "${D}${SRC_TAR_PATH}"

addtask tar_recipe_sources after do_populate_lic before do_configure
addtask ship_recipe_sources after do_install before do_package

python () {
    if not bb.data.inherits_class('native', d) and not bb.data.inherits_class('cross', d):
        d.setVarFlag('do_ship_recipe_sources', 'fakeroot', '1')

    if not(d.getVar('SHIP_SOURCE_ENABLED', True) == "1"):
        for i in ['do_tar_recipe_sources', 'do_ship_tar_sources']:
            bb.build.deltask(i, d)
}
