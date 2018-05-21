def get_mlprovides(provide,d) :
    mlvariants = d.getVar("MULTILIB_VARIANTS",True)
    rprovides = ""
    for each in mlvariants.split():
       rprovides = "%s %s-%s" % (rprovides, each, provide)
    return rprovides

DEPENDS_libstdc++-dev += "${@['','base-libstdc++-dev'][d.getVar('MLPREFIX', True) != '']} ${@['',get_mlprovides('libstdc++-dev', d)][d.getVar('MLPREFIX', True) == '']}"
RPROVIDES_libstdc++-dev += "${@['',get_mlprovides('base-libstdc++-dev', d)][d.getVar('MLPREFIX', True) == '']}"
