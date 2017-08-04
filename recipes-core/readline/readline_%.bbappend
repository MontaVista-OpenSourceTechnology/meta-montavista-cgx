# Copyright (c) 2012 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".4"

do_install_append () {
	# Install shared libraries in /lib, not /usr/lib
	mkdir ${D}/${base_libdir}
	mv ${D}/${libdir}/*.so.* ${D}/${base_libdir}
	ln -sf ../../$(basename ${base_libdir})/libreadline.so.${PV} ${D}/${libdir}/libreadline.so
	ln -sf ../../$(basename ${base_libdir})/libhistory.so.${PV} ${D}/${libdir}/libhistory.so
}
