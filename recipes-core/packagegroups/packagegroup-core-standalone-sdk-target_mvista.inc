def get_mlprovides(d) :
    mlvariants = d.getVar("MULTILIB_VARIANTS",True)
    rprovides = ""
    for each in mlvariants.split():
       rprovides = "%s %s-base-packagegroup-core-standalone-sdk-target" % (rprovides, each)
    return rprovides

RDEPENDS_${PN} += "${@['','base-packagegroup-core-standalone-sdk-target'][d.getVar('MLPREFIX', True) == '']}"
RPROVIDES_${PN} += "base-packagegroup-core-standalone-sdk-target ${@['',get_mlprovides(d)][d.getVar('MLPREFIX', True) == '']}"

RRECOMMENDS_${PN}_remove_toolchain-gcc = "libcxx-dev libcxx-staticdev"
