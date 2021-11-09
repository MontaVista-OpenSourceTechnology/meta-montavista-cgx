
#FIXME Need to create a test for use-ld and remove from native accordingly.
TARGET_CFLAGS:remove:class-native = "-fuse-ld=bfd"
TARGET_CXXFLAGS:remove:class-native = "-fuse-ld=bfd"
BUILD_CFLAGS:remove:class-native = "-fuse-ld=bfd"
OECMAKE_CXX_FLAGS:remove:class-native = "-fuse-ld=bfd"
OECMAKE_CXX_LINK_FLAGS:remove:class-native = "-fuse-ld=bfd"
