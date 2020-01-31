require git.inc

EXTRA_OECONF += "ac_cv_snprintf_returns_bogus=no \
                 ac_cv_fread_reads_directories=${ac_cv_fread_reads_directories=yes} \
                 "
EXTRA_OEMAKE += "NO_GETTEXT=1"

SRC_URI[tarball.md5sum] = "0cbe560e86a96c3223d545a2fa8c9ead"
SRC_URI[tarball.sha256sum] = "8f6434af7b1c7ee91f281f3f2bb88236992ac48699fdecaea8d855b722e37e96"
SRC_URI[manpages.md5sum] = "f8f6cc00e82b45b92caaa2db518df442"
SRC_URI[manpages.sha256sum] = "434eaad341acb0b6cc884154d469f145aab86f3cef8e66101681581b15031fa4"
