
require devel-image.bb
export IMAGE_BASENAME = "cgx-complete-image"

PROFILE_PKGS = "${@getprofiles(d)}"

def getprofiles(d):
    profiles = d.getVar("CGX_PROFILES",1)
    pkgs = ""
    for profile in profiles.split():
        pkgs = pkgs + " packagegroup-profile-" + profile
    return pkgs

IMAGE_INSTALL += "${PROFILE_PKGS}"
    
