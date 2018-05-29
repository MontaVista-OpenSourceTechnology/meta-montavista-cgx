# anonymous support class from angstrom
# 
# Features:
#
# * blacklist handling, set ANGSTROM_BLACKLIST_pn-blah = "message"
#

python () {
    import bb

    blacklist = d.getVar("PN_BLACKLIST", True)
    if not blacklist:
       basePackage = d.getVar("BPN", True)
       packageName = d.getVar("PN", True)
       mlPrefix = d.getVar("MLPREFIX", True)
       if ( packageName == mlPrefix + basePackage ):
          blacklist = d.getVar("PN_BLACKLIST_pn-%s" % basePackage, True)

    if blacklist:
        bb.debug(1, "%s" % (blacklist))
        raise bb.parse.SkipPackage("%s" % (blacklist))

}

