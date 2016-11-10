# Need to deal with cases where the kernel is older then the glibc
do_compile_prepend () {
        sed -i CMakeCache.txt -e s,KWSYS_CXX_HAS_UTIMENSAT_COMPILED:INTERNAL=TRUE,KWSYS_CXX_HAS_UTIMENSAT_COMPILED:INTERNAL=FALSE,
}

