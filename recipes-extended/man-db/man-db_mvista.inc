PR .= ".2"

inherit multilib_script
MULTILIB_SCRIPTS = "${PN}-doc:${docdir}/man-db/man-db-manual.ps \
                    ${PN}-doc:${docdir}/man-db/man-db-manual.txt \
		    "
