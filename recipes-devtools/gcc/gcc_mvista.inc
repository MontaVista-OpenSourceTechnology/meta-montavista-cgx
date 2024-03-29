
updateMips () {
    :
}

updateMips:linux-gnun32 () {
     cd ${B}
     cat > gcc/config/mips/t-linux64 << EOF

MULTILIB_OPTIONS = mabi=64/mabi=n32
MULTILIB_DIRNAMES = . 32
MULTILIB_OSDIRNAMES = ../lib64 ../lib32
EOF
}


EXTRACONFFUNCS += "updateMips"

do_install:append () {
     rm -f ${D}${bindir}/gcc
     rm -f ${D}${bindir}/cpp
     rm -f ${D}${bindir}/g++
}
ALLOW_EMPTY:cpp-symlinks = "1"
ALTERNATIVE_PRIORITY='${@oe.utils.conditional("PN", d.getVar("BPN", True), "110", "100", d)}'
pkg_postinst:gcc-symlinks () {
#!/bin/sh
    update-alternatives --install ${bindir}/gcc gcc ${TARGET_PREFIX}gcc ${ALTERNATIVE_PRIORITY}
}

pkg_prerm:gcc-symlinks () {
#!/bin/sh
    update-alternatives --remove gcc ${TARGET_PREFIX}gcc ${ALTERNATIVE_PRIORITY}
}

pkg_postinst:g++-symlinks () {
#!/bin/sh
    update-alternatives --install ${bindir}/g++ g++ ${TARGET_PREFIX}g++ ${ALTERNATIVE_PRIORITY}
}

pkg_prerm:g++-symlinks () {
#!/bin/sh
    update-alternatives --remove g++ ${TARGET_PREFIX}g++ ${ALTERNATIVE_PRIORITY}
}

pkg_postinst:cpp-symlinks () {
#!/bin/sh
    update-alternatives --install ${bindir}/cpp cpp ${TARGET_PREFIX}cpp ${ALTERNATIVE_PRIORITY}
}

pkg_prerm:cpp-symlinks() {
#!/bin/sh
    update-alternatives --remove cpp ${TARGET_PREFIX}cpp ${ALTERNATIVE_PRIORITY}
}

