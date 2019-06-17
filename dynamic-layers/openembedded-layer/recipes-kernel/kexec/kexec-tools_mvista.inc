PR.=".3"
MAKEDUMPFILE = "makedumpfile"
MAKEDUMPFILE_mips = ""
MAKEDUMPFILE_mips64 = ""
MAKEDUMPFILE_aarch64 = ""
RDEPENDS_kdump += "${MAKEDUMPFILE}"

SRC_URI += " file://0001-kexec-fix-for-Unhandled-rela-relocation-R_X86_64_PLT.patch"
