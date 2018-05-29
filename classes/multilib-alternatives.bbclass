
inherit update-alternatives multilib_header

def set_multilib_alternatives(d): 
     pkgs = (d.getVar("PACKAGES") or "").split()
     pkgs = d.expand(pkgs) 
     pkgsalt = {}
     for pkg in pkgs:
         epkg = d.expand(pkg)
         alts = (d.getVar("MULTILIB_ALTERNATIVES_%s" % epkg) or "").split()
         if alts:
            pkgsalt[epkg] = alts
     altheaders = (d.getVar("MULTILIB_HEADERS") or "").split()
     if not pkgsalt and not altheaders:
        return
     mlmoves=""
     for pkg in pkgsalt:
         altpkg = d.getVar("ALTERNATIVE_%s" % pkg) or ""
         for alt in pkgsalt[pkg]:
             altFlag = os.path.basename(alt)
             altpkg += " " + altFlag
             d.setVarFlag("ALTERNATIVE_TARGET", altFlag, alt + ".${PN}")
             d.setVarFlag("ALTERNATIVE_LINK_NAME", altFlag, alt)
             mlmoves += "mv ${D}%s ${D}%s.${PN}\n" % (alt, alt)
             files = d.getVar("FILES_%s" % pkg) or ""
             d.setVar("FILES_%s" % pkg, " ".join([files, alt + ".${PN}"]))
         d.setVar("ALTERNATIVE_%s" % pkg, altpkg)
     for header in altheaders:
         mlmoves += "oe_multilib_header %s\n" % header
     # Make sure moves are in the same order to avoid changing hash values
     splitmoves = mlmoves.split("\n")
     splitmoves.sort()
     mlmoves = "\n".join(splitmoves)
     d.setVar("MULTILIB_INSTALL_MOVES", mlmoves)
     print (mlmoves)
python () {
     set_multilib_alternatives(d)
}

do_install_append_class-target () {
     ${MULTILIB_INSTALL_MOVES} 
}
