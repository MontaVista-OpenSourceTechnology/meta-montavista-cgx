LDFLAGS += "-lm"
do_compile:prepend () {
	
	sed -i ${S}/Make.rules -e "s,-lm,,"
}
