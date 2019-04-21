# Copyright (C) 2009 MontaVista Software, Inc.
# Released under the MIT license (see COPYING.MIT for the terms)

LICENSE="MIT"
SUMMARY="Information for MontaVista support"
DESCRIPTION = "Information for MontaVista support"
INHIBIT_DEFAULT_DEPS = "1"
PSTAGING_DISABLED = "1"
DEPENDS += "pseudo-native"
PR = "${DISTRO_VERSION}"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
SRC_URI = "file://mvl-supportinfo"
SSTATE_DISABLE = "1"
mvldir = "${sysconfdir}/mvlcgx${PR}"
mvlfiles = "conf/bblayers.conf conf/local-content.conf conf/local.conf"
do_install_bits[nostamp] = "${@bb.utils.contains("CGX_PROFILES", "base", "1", "", d)}"
do_install[nostamp] = "${@bb.utils.contains("CGX_PROFILES", "base", "1", "", d)}"
do_compile[nostamp] = "${@bb.utils.contains("CGX_PROFILES", "base", "1", "", d)}"
do_install[noexec] = "1"
PACKAGES="${PN}"

addtask do_install_bits before do_install after do_compile

fakeroot python do_install_bits () {
    import shutil, logging, os

    destdir = d.getVar("D")
    mvldir = "/".join([destdir, d.getVar("mvldir")])
    bb.utils.mkdirhier(os.path.join(mvldir, "conf"))
     
    # Store specified configuration files
    for fn in d.getVar("mvlfiles").split():
        fromfn = bb.utils.which(d.getVar("BBPATH"), fn)
        if not fromfn:
            bb.warn("Unable to install %s from BBPATH, skipping." % fn)
            continue

        destfn = os.path.join(mvldir, fn)
        bb.utils.mkdirhier(os.path.dirname(destfn))
        shutil.copyfile(fromfn, destfn)

    # Emit current configuration metadata
    bb.data.update_data(d)
    emitted = open("/".join([mvldir, "conf", "emitted.inc"]), "w")

    bb.data.emit_env(emitted, d, True)
    bb.build.exec_func("do_install_script", d)
}

fakeroot do_install_script () {
    install -d ${D}${bindir}
    cat ${WORKDIR}/mvl-supportinfo | \
        sed -e's,@sysconfdir@,${sysconfdir},g' > ${D}${bindir}/mvl-supportinfo
    chmod +x ${D}${bindir}/mvl-supportinfo
    if [ -e ${TOPDIR}/.mvl-content/project-descriptor.xml ] ; then
         cp ${TOPDIR}/.mvl-content/project-descriptor.xml ${D}${mvldir}/conf/
    fi
    chown -R root:root ${D}
}
