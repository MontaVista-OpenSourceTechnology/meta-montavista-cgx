do_compile_prepend_linux-gnuilp32 () {
      pushd ${S}
      sed -e "s,-Werror,,g" -i Makefile
}
