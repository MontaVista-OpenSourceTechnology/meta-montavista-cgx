PR .= ".1"

do_install_append () {
       # Change server port to 90, as port 80 is also used by
       # apache2 server.
       sed -i "s:listen       80;:listen       90;:g" ${D}${sysconfdir}/nginx/nginx.conf
}
