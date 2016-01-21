DESCRIPTION = "a portable and efficient C programming interface (API) to determine the call-chain of a program"
HOMEPAGE = "http://www.nongnu.org/libunwind"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3fced11d6df719b47505837a51c16ae5 \
                    file://COPYING;md5=2d80c8ed4062b8339b715f90fa68cc9f \
		    "
PR = "r13"

SRCREV="396b6c7ab737e2bff244d640601c436a26260ca1"
SRC_URI = "git://git.sv.gnu.org/libunwind.git;protocal=git \
           file://avoid_latex2man_pdflatex_for_docs.patch \
           file://libunwind_aarch64_ILP32_support.patch \
           file://mips_testcases_fix.patch \
           file://arm_testcases_fix.patch \
           file://ignore_invalid_regnum_in_DW_CFA_offset_extended.patch \
           file://libunwind_fix_other_test_cases_for_AARCH64_ILP32.patch \
	   file://add_attribute_used_to_retain_static_variable.patch \
          "

# Install libunwind header files in /usr/include/libunwind directory"
EXTRA_OECONF += " --includedir=/usr/include/libunwind " 

# Pull xz, since libunwind depends on liblzma
DEPENDS += "xz"

S = "${WORKDIR}/git"

LEAD_SONAME = "libunwind"

inherit autotools

EXTRA_OECONF_arm = "--enable-debug-frame"

BBCLASSEXTEND = "native"
