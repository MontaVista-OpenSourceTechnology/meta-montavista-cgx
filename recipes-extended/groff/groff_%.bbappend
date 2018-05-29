PR .= ".1"

inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "${bindir}/grog ${bindir}/groffer \
                               ${bindir}/afmtodit ${bindir}/chem \
			       ${bindir}/gropdf ${bindir}/gpinyin"

EXTRA_OECONF_append += "--mandir=${datadir}/${PN}/man --docdir=${datadir}/doc/${PN}-${PV}/"
EXTRA_OEMAKE_class-target += "dataprogramdir='${datadir}/${PN}/'"
FILES_${PN} += "${datadir}/${PN}"
