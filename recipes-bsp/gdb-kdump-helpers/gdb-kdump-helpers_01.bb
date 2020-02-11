DESCRIPTION = "GDB macro for making analyzing kernel dump easy"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=79808397c3355f163c012616125c9e26"
PR = "r3"
RDEPENDS_${PN} = "gdb python3"
SECTION = "devel"
SRC_URI = "file://LICENSE file://arm-gdbinit_commit file://powerpc-gdbinit_commit file://mips-gdbinit_commit file://x86-gdbinit_commit  file://gdbinit.py"

do_install() {
	install -d  ${D}/usr/share/gdb/macros/gdb-kdump-helpers
	install -m 0644 ${WORKDIR}/LICENSE ${D}/usr/share/gdb/macros/gdb-kdump-helpers/

  case ${TARGET_ARCH} in
    arm*|aarch64*)    ARCH=arm ;;
    mips*)    ARCH=mips ;;
    powerpc*) ARCH=powerpc ;;
    x86_64*)  ARCH=x86 ;;
	  i*86*)    ARCH=x86 ;;
  esac

	install -m 0644 ${WORKDIR}/${ARCH}-gdbinit_commit ${D}/usr/share/gdb/macros/gdb-kdump-helpers/gdbinit_commit
	install -m 0644 ${WORKDIR}/gdbinit.py ${D}/usr/share/gdb/macros/gdb-kdump-helpers/
}

FILES_${PN} = "/usr/share/gdb/macros/gdb-kdump-helpers"

