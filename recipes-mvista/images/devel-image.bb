require recipes-core/images/core-image-base.bb

export IMAGE_BASENAME = "devel-image"
IMAGE_INSTALL += "packagegroup-self-hosted kernel-dev kernel-modules openssh \
                  gdb"
