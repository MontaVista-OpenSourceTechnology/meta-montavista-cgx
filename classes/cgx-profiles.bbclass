CGX_DEFINED_PROFILES = ""

CGX_PROFILES += "${@checkprofiles(d)}"

def checkprofiles(d):
    profiles = d.getVar("CGX_DEFINED_PROFILES", 1)
    layers = d.getVar("BBFILE_COLLECTIONS", 1)
    profileList = ""

    if layers:
       layersSet = set(layers.split())
 
    for profile in profiles.split():
        profileLayers = d.getVar("CGX_PROFILE_" + profile, 1)
        if profileLayers:
           if set(profileLayers.split()).issubset(layersSet):
              profileList += " " + profile
    return profileList

