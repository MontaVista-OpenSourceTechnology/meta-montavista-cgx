inherit multilib-alternatives
MULTILIB_ALTERNATIVES_${PN} = "${bindir}/grog ${bindir}/groffer \
                               ${bindir}/afmtodit ${bindir}/chem \
			       ${bindir}/gropdf ${bindir}/gpinyin"

EXTRA_OEMAKE_class-target += "dataprogramdir='${datadir}/${PN}/'"
FILES_${PN} += "${datadir}/${PN}"
