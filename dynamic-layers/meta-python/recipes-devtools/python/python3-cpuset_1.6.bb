SUMMARY = "Cpuset is a Python application to make using the cpusets facilities in the Linux kernel easier"
SECTION = "devel/python"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"
PYPI_PACKAGE = "cpuset-py3"
S = "${WORKDIR}/git"
SRCREV = "1eeb1ebd8b78b34a86de6da7909fcdecc8b6fd5c"
SRC_URI = "git://github.com/parttimenerd/cpuset;protocol=https;"

inherit setuptools3

RDEPENDS_${PN} = "\
    python3-core \
    python3-pkg-resources \
    python3-logging \
    python3-plistlib \
    python3-pyparsing \
    "
