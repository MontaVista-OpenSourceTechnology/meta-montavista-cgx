def get_mlprovides(provide,d) :
    if bb.data.inherits_class('nativesdk', d):
       return ""
    mlvariants = d.getVar("MULTILIB_VARIANTS",True)
    rprovides = ""
    for each in mlvariants.split():
       rprovides = "%s %s-%s" % (rprovides, each, provide)
    return rprovides

RPROVIDES:${PN}:append:class-target += "${@['','base-libgcc'][d.getVar('MLPREFIX', True) == '']}"

RDEPENDS:${PN}-dev:append:class-target += "${@['','base-libgcc-dev'][d.getVar('MLPREFIX', True) != '']}"
RDEPENDS:${PN}-dev:append:class-target += "${@['',get_mlprovides('libgcc-dev', d)][d.getVar('MLPREFIX', True) == '']}"
RDEPENDS:${PN}-dev:append_:class-target += "${@['','base-libgcc'][d.getVar('MLPREFIX', True) == '']}"

RPROVIDES:${PN}-dev:append:class-target += "${@['',get_mlprovides('base-libgcc-dev', d)][d.getVar('MLPREFIX', True) == '']}"

