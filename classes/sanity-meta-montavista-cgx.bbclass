addhandler mmcgx_bbappend_distrocheck
mmcgx_bbappend_distrocheck[eventmask] = "bb.event.SanityCheck"
python mmcgx_bbappend_distrocheck() {
    skip_check = e.data.getVar('SKIP_META_MONTAVISTA_CGX_SANITY_CHECK') == "1"
    if 'mvista-base' not in e.data.getVar('DISTRO_FEATURES').split() and not skip_check:
        bb.warn("You have included the meta-montavista-cgx layer, but \
'mvista-base' has not been enabled in your DISTRO_FEATURES. Some bbappend files \
and preferred version setting may not take effect. See the meta-montavista-cgx README \
for details on enabling montavista support for foundation/base recipes.")
}

require ${@bb.utils.contains('DISTRO_FEATURES', 'mvista-base', 'conf/mvista-base-default-versions.inc', '', d)}
