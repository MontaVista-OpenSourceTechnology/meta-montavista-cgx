FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " \
            file://mv.cfg \
"
DEPENDS += "libtirpc"
EXTRA_CFLAGS += "-I${STAGING_INCDIR}/tirpc"
EXTRA_LDFLAGS += "-ltirpc"

python create_sh_wrapper_reset_alternative_vars:append () {
    #Remove Dups
    d.setVar('ALTERNATIVE:%s' % (pn), " ".join(set(d.getVar('ALTERNATIVE:%s' % (pn)).split())))
}
