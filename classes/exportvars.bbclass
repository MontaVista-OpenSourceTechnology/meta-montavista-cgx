# Copyright (c) 2010 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

EXPORTVARS ?= "PN PE PV PR SECTION PRIORITY HOMEPAGE SRC_URI LICENSE SUMMARY DESCRIPTION DEPENDS RDEPENDS FILE S B P WORKDIR PACKAGES PROVIDES RPROVIDES RRECOMMENDS"
EXPORTCOLLECTIONVARS ?= "PN PE PV PR FILE LICENSE SUMMARY DESCRIPTION PACKAGES"
EXPORTVARSDIR ?= "${TMPDIR}/export/"
EXPORTVARSFILE ?= "${EXPORTVARSDIR}/${PN}-${PV}"
EXPORTCOLLSFILE ?= "${EXPORTVARSDIR}/collections-mapping"
CFGSIGBLACKLIST += "EXPORTVARS EXPORTVARSDIR EXPORTVARSFILE EXPORTCOLLSFILE EXPORTVARSRUN EXPORTCOLLECTIONVARS"
EXPORTVARSRUN ?= "0"

python () {
    if d.getVar("EXPORTVARSRUN",d,1) == "1":
        exportvarsrun (d)
}

def exportvarsrun (d):

    evrecpietype = set(d.getVar("__inherit_cache",d,1))
    evcollectioninfo = d.getVar('LAYER_NAME', 1)
    bb.utils.mkdirhier(bb.data.expand("${EXPORTVARSDIR}",d))

    collfile = open(bb.data.expand("${EXPORTCOLLSFILE}",d), "a")
    for collvar in d.getVar("EXPORTCOLLECTIONVARS",d,1).split(" "):
      collfile.write('%s="%s",' % (collvar, d.getVar(collvar,d,1)))
    if evcollectioninfo:
        collfile.write('COLLECTION="%s"\n' % evcollectioninfo)
    else:
        collfile.write('COLLECTION="%s"\n' % "")
    collfile.close()

    evfile = open(bb.data.expand("${EXPORTVARSFILE}",d), "w")
    if evcollectioninfo:
        evfile.write('COLLECTION="%s"\n' % evcollectioninfo)
    else:
        evfile.write('COLLECTION="%s"\n' % "")
    for expvar in d.getVar("EXPORTVARS",d,1).split(" "):
        evfile.write('%s="%s"\n' % (expvar, d.getVar(expvar,d,1)))
    evfile.close()

