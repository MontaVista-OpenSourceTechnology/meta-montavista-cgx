FILESEXTRAPATHS_prepend := "${THISDIR}/gdb-7.11.1:"

SRC_URI += " \
file://0001-Fix-compiling-with-newer-libiberty.patch \
file://0002-Fix-ARMv8.1-v8.2-for-hw-watchpoint-and-breakpoint.patch \
file://0003-Move-AARCH64-ILP32-rejection-handling.patch \
file://0004-Add-ILP32-support-to-gdb.patch \
file://0006-Fix-non-C-build-of-gdb.patch \
file://0007-Handle-ILP32-AARCH64-correctly-for-gdbserver.patch \
file://0008-Fix-ILP32-check-until-addrbits-is-changed.patch \
file://0009-Fix-gdbserver-the-rest-of-the-way-pc-should-be-a-64b.patch \
"
