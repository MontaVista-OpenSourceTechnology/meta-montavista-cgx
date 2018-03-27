
LAYER_NAME="${@ get_layername(d.getVar("FILE",d,1),d)}"
SOURCE_MIRROR_URL?="${@get_layermirror(d)}/"
inherit own-mirrors

def get_layername(file, d):
    import re
    if not os.path.isabs(file):
        file = bb.which(d.getVar("BBPATH", 1), file)
    filedir = os.path.realpath(os.path.dirname(file))
    named = (d.getVar("BBLAYERS_NAMED",1) or "").split()
    for layer in named:
        splitname = layer.split(":")

        if len(splitname) == 2:
            if re.search("^%s" % splitname[1], file):
                return splitname[0]
    for layername in d.getVar("BBFILE_COLLECTIONS", 1).split():
        bbpattern=d.getVar("BBFILE_PATTERN_%s" % layername,1)
        if bbpattern and re.search(bbpattern, file):
            return layername
    return ""

def get_layermirror(d):
    layer = d.getVar("LAYER_NAME",1)
    layer_mirror = d.getVar("LAYER_SOURCES_%s" % layer , 1) or "file://${TOPDIR}/sources"
    return layer_mirror
