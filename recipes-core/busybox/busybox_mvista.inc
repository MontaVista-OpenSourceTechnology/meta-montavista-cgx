FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-Add-save-baud-rate-patch.patch;apply=no \
            file://mv.cfg \
"
DEPENDS += "libtirpc"
EXTRA_CFLAGS += "-I${STAGING_INCDIR}/tirpc"
EXTRA_LDFLAGS += "-ltirpc"

python create_sh_wrapper_reset_alternative_vars_append () {
    #Remove Dups
    d.setVar('ALTERNATIVE_%s' % (pn), " ".join(set(d.getVar('ALTERNATIVE_%s' % (pn)).split())))
}
