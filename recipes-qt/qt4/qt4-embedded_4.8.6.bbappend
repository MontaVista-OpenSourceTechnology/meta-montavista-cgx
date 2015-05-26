# Copyright (c) 2012,2013 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)
#

PR .= ".4"

DEPENDS += "pkgconfig pkgconfig-native"
FILESEXTRAPATHS_append := ":${THISDIR}/qt-${PV}"

SRC_URI += "file://qt-cross-prefix-fix.patch \
            file://define_aarch64_arch.patch \
            file://define_mips64_arch.patch \
            file://check_for_aarch64_32_bit_variant.patch"

EXTRA_ENV = 'QMAKE="${STAGING_BINDIR_NATIVE}/qmake2 -after \
             INCPATH+=${STAGING_INCDIR}/freetype2 LIBS+=-L${STAGING_LIBDIR}" \
             QMAKESPEC="${QMAKESPEC}" LINK="${CXX} -Wl,-rpath-link,${STAGING_LIBDIR}/pulseaudio" \
             AR="${TARGET_PREFIX}ar cqs" \
             MOC="${STAGING_BINDIR_NATIVE}/moc4" UIC="${STAGING_BINDIR_NATIVE}/uic4" MAKE="make -e"'

# Disable neon functionality
QT_CONFIG_FLAGS_append_armv7a = " -no-neon "

# Some libraries are present in ${libdir}/pulseaudio directory, so
# adding them in rpath-link.
do_configure_prepend() {
	export OE_QMAKE_LDFLAGS="${OE_QMAKE_LDFLAGS} -Wl,-rpath-link,${STAGING_LIBDIR}/pulseaudio"
}
