PR .= ".1"

DEPENDS += "bzip2"
PACKAGECONFIG_append = " libusb virtfs "
EXTRA_OECONF_remove = " --python=${USRBINPATH}/python2.7 "
EXTRA_OECONF_append = " --python=${USRBINPATH}/python "
LDFLAGS_remove = "-fuse-ld=bfd"
do_configure_preped () {
        cat > test_main.c << EOF
        int main () {return 0;}
EOF
        if ! $CC -fuse-ld=bfd test_main.c ; then
                export LDFLAGS=$(echo $LDFLAGS | sed s,-fuse-ld=bfd,,)
        fi
}
