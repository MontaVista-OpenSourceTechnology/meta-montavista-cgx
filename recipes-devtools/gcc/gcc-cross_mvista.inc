
LANGUAGES:append =",go"
NATIVEDEPS:append  = " zstd-native "
do_configure:append () {
     sed -i config.status -e '/if\ gotools/d' -e 's,\ gotools\ ,\ ,'
     ./config.status
}
