TOOLCHAIN_DIR ?= "${MULTIMACH_TARGET_SYS}"

do_install () {
        set -x 
        LOCALETREESRC=$(ls -d ${STAGING_INCDIR}/glibc-locale-internal-* | head -n 1)
	mkdir -p ${D}${bindir} ${D}${datadir} ${D}${libdir}
	if [ -n "$(ls $LOCALETREESRC/${bindir})" ]; then
		cp -fpPR $LOCALETREESRC/${bindir}/* ${D}${bindir}
	fi
	if [ -n "$(ls $LOCALETREESRC/${localedir})" ]; then
		mkdir -p ${D}${localedir}
		cp -fpPR $LOCALETREESRC/${localedir}/* ${D}${localedir}
	fi
	if [ -e $LOCALETREESRC/${libdir}/gconv ]; then
		cp -fpPR $LOCALETREESRC/${libdir}/gconv ${D}${libdir}
	fi
	if [ -e $LOCALETREESRC/${datadir}/i18n ]; then
		cp -fpPR $LOCALETREESRC/${datadir}/i18n ${D}${datadir}
	fi
	if [ -e $LOCALETREESRC/${datadir}/locale ]; then
		cp -fpPR $LOCALETREESRC/${datadir}/locale ${D}${datadir}
	fi
	chown root.root -R ${D}
	cp -fpPR $LOCALETREESRC/SUPPORTED ${WORKDIR}
}
do_prep_locale_tree() {
        LOCALETREESRC=$(ls -d ${STAGING_INCDIR}/glibc-locale-internal-* | head -n 1)
        treedir=${WORKDIR}/locale-tree
        rm -rf $treedir
        mkdir -p $treedir/${base_bindir} $treedir/${base_libdir} $treedir/${datadir} $treedir/${localedir}
        tar -cf - -C $LOCALETREESRC${datadir} -p i18n | tar -xf - -C $treedir/${datadir}
        # unzip to avoid parsing errors
        for i in $treedir/${datadir}/i18n/charmaps/*gz; do
                gunzip $i
        done
        tar -cf - -C $LOCALETREESRC${base_libdir} -p . | tar -xf - -C $treedir/${base_libdir}
        if [ -f ${STAGING_DIR_NATIVE}${prefix_native}/lib/libgcc_s.* ]; then
                tar -cf - -C ${STAGING_DIR_NATIVE}/${prefix_native}/${base_libdir} -p libgcc_s.* | tar -xf - -C $treedir/${base_libdir}
        fi
        install -m 0755 $LOCALETREESRC${bindir}/localedef $treedir/${base_bindir}
}

inherit libc-package

BBCLASSEXTEND = "nativesdk"
