#
# Copyright (C) 2015 Montavista LLC
#

SUMMARY = "MontaVista Software LLC packages"
DESCRIPTION = "Features required to implement MontaVista Software LLC functionality"
LICENSE = "MIT"


inherit packagegroup

PACKAGES = "\
    ${PN} \
	"
ALLOW_EMPTY_${PN} = "1"

RDEPENDS_${PN} = "\
    os-release \
	"

