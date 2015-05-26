PR .= ".2"
FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}-${PV}:"

SRC_URI += "file://fix_assert_failure_in_eu_strings.patch \
            file://mips_testcase_fix.patch \
           "
