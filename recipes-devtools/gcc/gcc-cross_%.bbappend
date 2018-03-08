
LANGUAGES_append =",go"

do_configure_append () {
     sed -i config.status -e '/if\ gotools/d' -e 's,\ gotools\ ,\ ,'
     ./config.status
}

EXTRA_OECONF_append_linux-gnuilp32 = " \
    --with-multilib-list='ilp32 lp64'"
