
LANGUAGES_append =",go"

do_configure_append () {
     sed -i config.status -e '/if\ gotools/d' -e 's,\ gotools\ ,\ ,'
     ./config.status
}
