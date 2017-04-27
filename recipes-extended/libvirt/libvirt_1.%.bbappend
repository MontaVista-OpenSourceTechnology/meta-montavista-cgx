PR .= ".2"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_install_append() {
        if [ "${LIBVIRT_PYTHON_ENABLE}" = "1" ]; then
                cd ${WORKDIR}/${BPN}-python-${PV} && \
                  ${STAGING_BINDIR_NATIVE}/python-native/python setup.py install \
                       --install-lib=${D}/${PYTHON_SITEPACKAGES_DIR} ${LIBVIRT_INSTALL_ARGS}
        fi
}

PACKAGECONFIG[wireshark] = "--with-wireshark-dissector,--without-wireshark-dissector,wireshark"
PACKAGECONFIG_remove_mips64 = "qemu"
PACKAGECONFIG_remove_linux-gnuilp32 = "qemu"
