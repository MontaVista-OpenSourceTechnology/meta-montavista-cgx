
LANGUAGES:append =",go"

do_configure:append () {
     sed -i config.status -e '/if\ gotools/d' -e 's,\ gotools\ ,\ ,'
     ./config.status
}
