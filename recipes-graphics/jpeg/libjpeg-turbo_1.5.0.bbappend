# Work around missing non-floating point ABI support in MIPS
EXTRA_OECONF_append_class-target = " ${@bb.utils.contains("MIPSPKGSFX_FPU", "_nf", "--without-simd", "", d)}"
