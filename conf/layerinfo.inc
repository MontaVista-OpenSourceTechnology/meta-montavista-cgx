BB_HASHBASE_WHITELIST_append = " PROTECTED_SOURCE_URL PERSONAL_SOURCE_MIRROR MVLFETCH_OPTS MVLFETCH "
BB_HASHBASE_WHITELIST_append = " FETCHCMD_wget USE_MVLFETCH "

LAYER_NAME="${@ get_layername(d.getVar("FILE",d,1),d)}"
SOURCE_MIRROR_URL?="${@get_layermirror(d)}/"
inherit own-mirrors
PROTECTED_SOURCE_URL ?= ""
PERSONAL_SOURCE_MIRROR ?= ""
MVLFETCH_OPTS ?= ""
MVLFETCH ?= "/usr/bin/env mvl-fetch ${MVLFETCH_OPTS}"
USE_MVLFETCH ?= "0"
FALLBACK_MIRROR ?= "https://raw.githubusercontent.com/MontaVista-OpenSourceTechnology/source-mirror/master/"
INHERIT += "mirrors"
def get_layername(file, d):
    import re
    if not os.path.isabs(file):
        file = bb.utils.which(d.getVar("BBPATH", 1), file)
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

def get_layerdir(file, d):
    layer = get_layername(file,d)
    bbpattern=d.getVar("BBFILE_PATTERN_%s" % layer,1)
    return os.path.normpath(bbpattern.replace("^",""))

MVLBASE="${@ get_layerdir('conf/layerinfo.inc',d)}"
def get_layermirror(d):
    layer = d.getVar("LAYER_NAME",1)
    layer_mirror = d.getVar("LAYER_SOURCES_%s" % layer , 1) or d.getVar("FALLBACK_MIRROR", 1) 
    return layer_mirror

def set_source_mirror(d):
    if d.getVar("NO_SOURCE_MIRROR") == "1":
       return
    layer = d.getVar("LAYER_NAME")
    source_url=d.getVar("SOURCE_MIRROR_URL")
    protected_mirror = d.getVar("PROTECTED_SOURCES_%s" % layer)
    protected_url = d.getVar("PROTECTED_SOURCE_URL_%s" % layer)
    if not protected_url: 
       protected_url = d.getVar("PROTECTED_SOURCE_URL")
    if protected_mirror == "1" and protected_url:
       source_url=protected_url
       d.setVar("SOURCE_MIRROR_URL", source_url)
    personal_mirror = d.getVar("PERSONAL_SOURCE_MIRROR_%s" % layer)
    if not personal_mirror:
       personal_mirror = d.getVar("PERSONAL_SOURCE_MIRROR")
    if personal_mirror:
       source_url=personal_mirror
       d.setVar("SOURCE_MIRROR_URL", personal_mirror)

def mvlbase_path_element(d):
    source_url=d.getVar("SOURCE_MIRROR_URL")
    if (source_url and source_url.startswith("https://") and source_url.find("mvista.com") != -1) or d.getVar("USE_MVLFETCH") == "1":
       mvlbase=d.getVar("MVLBASE")
       pathadd=None
       mvlfetch = d.getVar("MVLFETCH")
       if mvlfetch:
          d.setVar("FETCHCMD_wget", mvlfetch)
       if mvlbase:
         pathadd = os.path.dirname(os.path.dirname(mvlbase)) + "/bin:"
         return pathadd
       else:
         return ""
    return ""
python() {
    set_source_mirror(d)
}

PATH_prepend = "${@mvlbase_path_element(d)}"
