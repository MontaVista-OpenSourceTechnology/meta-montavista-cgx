PR .= ".1"

B = "${S}"

do_configure_prepend () {
    ./autogen.sh
}
