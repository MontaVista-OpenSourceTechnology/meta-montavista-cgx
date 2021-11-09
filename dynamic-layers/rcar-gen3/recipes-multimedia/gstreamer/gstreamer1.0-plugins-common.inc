PR .= ".1"

do_init_submodule:prepend () {
    export GIT_SSL_NO_VERIFY=1
}
