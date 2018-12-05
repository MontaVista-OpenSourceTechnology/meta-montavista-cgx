inherit multilib_script
MULTILIB_SCRIPTS = "${PN}-dev:${bindir}/apr-1-config \
                    ${PN}-dev:${datadir}/build-1/apr_rules.mk"
