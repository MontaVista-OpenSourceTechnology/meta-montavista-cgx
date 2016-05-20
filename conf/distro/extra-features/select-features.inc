include base-feature.conf

# Display available Kernel fragment IMAGE_FEATURES 
def getAvailableImageFeatures(d):
    valid_features = []
    for var in d:
       if var.startswith("FEATURE_PACKAGES_"):
           valid_features.append(var[17:])
    return ' '.join(valid_features)

KERNEL_IMAGE_FEATURES = "${@getAvailableImageFeatures(d)}"
