DEPENDS_append += "rsyslog nginx"

VIRTUAL-RUNTIME_webserver ?= "apache2"
RDEPENDS_packagegroup-oe-webserver_append = " \
	${VIRTUAL-RUNTIME_webserver} \
"
