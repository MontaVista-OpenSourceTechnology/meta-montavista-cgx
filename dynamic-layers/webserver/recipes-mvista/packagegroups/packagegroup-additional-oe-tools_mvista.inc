DEPENDS:append += "rsyslog nginx"

VIRTUAL-RUNTIME_webserver ?= "apache2"
RDEPENDS:packagegroup-oe-webserver:append = " \
	${VIRTUAL-RUNTIME_webserver} \
"
