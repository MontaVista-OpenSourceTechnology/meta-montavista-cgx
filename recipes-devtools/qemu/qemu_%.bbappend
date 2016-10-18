PR .= ".1"

DEPENDS += "bzip2"
PACKAGECONFIG_append = " libusb virtfs "

do_configure_prepend () {
        cat > test_main.c << EOF
        int main () {return 0;}
EOF
        if ! $CC -fuse-ld=bfd test_main.c ; then
                export LDFLAGS=$(echo $LDFLAGS | sed s,-fuse-ld=bfd,,)
        fi
}
