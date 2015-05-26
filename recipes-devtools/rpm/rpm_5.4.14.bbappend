FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}-${PV}:"
PR .= ".5"

SRC_URI += "file://rpm-fix-rpm2cpio-segmentation-fault.patch \
            file://fix_to_check_rpm_type.patch \
	    file://rpmdb-segmentation-fault.patch \
	    file://rpm-segmentation-fault.patch \
"
