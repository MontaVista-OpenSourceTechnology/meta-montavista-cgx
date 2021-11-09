# openvswitch-controller has been renamed to openvswitch-testcontroller
IMAGE_INSTALL:remove = "openvswitch-controller"
IMAGE_INSTALL:append += " openvswitch-testcontroller "
