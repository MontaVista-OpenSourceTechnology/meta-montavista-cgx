python create_sh_wrapper_reset_alternative_vars_append () {
    #Remove Dups
    d.setVar('ALTERNATIVE_%s' % (pn), " ".join(set(d.getVar('ALTERNATIVE_%s' % (pn)).split())))
}
