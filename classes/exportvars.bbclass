# Copyright (c) 2010 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

EXPORTVARS ?= "PN PE PV PR SECTION PRIORITY HOMEPAGE SRC_URI LICENSE SUMMARY DESCRIPTION DEPENDS RDEPENDS FILE S B P WORKDIR PACKAGES PROVIDES RPROVIDES RRECOMMENDS"
EXPORTCOLLECTIONVARS ?= "PN PE PV PR FILE LICENSE SUMMARY DESCRIPTION PACKAGES"
EXPORTVARSDIR ?= "${TMPDIR}/export/"
EXPORTVARSFILE ?= "${EXPORTVARSDIR}/${PN}-${PV}"
EXPORTCOLLSFILE ?= "${EXPORTVARSDIR}/collections-mapping"
EXPORTVARSRUN ?= "0"

python () {
    if bb.data.getVar("EXPORTVARSRUN",d,1) == "1":
        exportvarsrun (d)
}

def exportvarsrun (d):

    evrecpietype = set(bb.data.getVar("__inherit_cache",d,1))
    evcollectioninfo = d.getVar('LAYER_NAME', 1)
    bb.utils.mkdirhier(bb.data.expand("${EXPORTVARSDIR}",d))

    collfile = open(bb.data.expand("${EXPORTCOLLSFILE}",d), "a")
    for collvar in bb.data.getVar("EXPORTCOLLECTIONVARS",d,1).split(" "):
      collfile.write('%s="%s",' % (collvar, bb.data.getVar(collvar,d,1)))
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
    for expvar in bb.data.getVar("EXPORTVARS",d,1).split(" "):
        evfile.write('%s="%s"\n' % (expvar, bb.data.getVar(expvar,d,1)))
    evfile.close()

def prune_exportvars(d):
    import os
    import oe

    map = d.getVar("EXPORTCOLLSFILE", True)
    exportdir = d.getVar("EXPORTVARSDIR", True)
    if os.path.isfile(map):
       packages=open(map).readlines()
    else:
       bb.warn("Could not find collections-mapping")
       return
    pkgsout={}
    for package in packages:
        pack = package.split(",")
        pn = pack[0].split('"')[1]
        pv = pack[2].split('"')[1]
        if os.path.isfile(pack[4].split('"')[1]):
           pkgsout["%s-%s" % (pn,pv)] = package
        else:
           varfile = exportdir + "/" + pn + "-" + pv
           if os.path.isfile(varfile):
              os.remove(varfile)
    output =""
    for pkg in pkgsout.keys():
        output += pkgsout[pkg]
    mapf = open(map, "w")
    mapf.write(output)
    mapf.close()
 
python prune_exportvars_eh () {
    from bb.event import ConfigParsed, RecipeParsed, ParseCompleted

    if e.data.getVar("EXPORTVARSRUN",1) == "1" and isinstance(e, ParseCompleted):
       prune_exportvars(e.data) 

}
prune_exportvars_eh[eventmask] = "bb.event.ParseCompleted"
addhandler prune_exportvars_eh
