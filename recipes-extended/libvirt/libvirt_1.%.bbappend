do_install_append() {
        if [ "${LIBVIRT_PYTHON_ENABLE}" = "1" ]; then
                cd ${WORKDIR}/${BPN}-python-${PV} && \
                  ${STAGING_BINDIR_NATIVE}/python-native/python setup.py install \
                       --install-lib=${D}/${PYTHON_SITEPACKAGES_DIR} ${LIBVIRT_INSTALL_ARGS}
        fi
}

