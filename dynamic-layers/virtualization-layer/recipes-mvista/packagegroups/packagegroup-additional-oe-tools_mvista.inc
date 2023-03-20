RDEPENDS:packagegroup-oe-security:append = " \
	cyrus-sasl \
"

# Remove ntpdate, as its functionality has been moved in to ntpd
# ntpd -q -g -x
RDEPENDS:packagegroups-oe-networkmanagement:append = " \
	ntp \
	ntp-utils \
"
