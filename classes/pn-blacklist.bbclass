# anonymous support class from angstrom
# 
# Features:
#
# * blacklist handling, set ANGSTROM_BLACKLIST_pn-blah = "message"
#

python () {
    import bb

    blacklist = bb.data.getVar("PN_BLACKLIST", d, 1)
    if not blacklist:
       basePackage = bb.data.getVar("BPN", d, 1)
       packageName = bb.data.getVar("PN", d, 1)
       mlPrefix = bb.data.getVar("MLPREFIX", d, 1)
       if ( packageName == mlPrefix + basePackage ):
          blacklist = bb.data.getVar("PN_BLACKLIST_pn-%s" % basePackage, d, 1)

    if blacklist:
        bb.debug(1, "%s" % (blacklist))
        raise bb.parse.SkipPackage("%s" % (blacklist))

}

