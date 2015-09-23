class lsmod (gdb.Command):
	def __init__ (self):
		super (lsmod, self).__init__ ("lsmod", gdb.COMMAND_OBSCURE)

	def invoke (self, args, from_tty):
		argv = gdb.string_to_argv(args)
		modules = long(gdb.parse_and_eval("&modules"))
		modules_next = long(gdb.parse_and_eval("modules.next"))
		while modules_next != modules:
			gdb.execute("kvtop 0x%lx" %   modules_next)
			modules_next_phys =  long(gdb.parse_and_eval("(ulong)$ret")) - 4
			modname = gdb.parse_and_eval("(*(struct module*)(0x%lx)).name" % modules_next_phys)
			core_size = gdb.parse_and_eval("(*(struct module*)(0x%lx)).core_size" % modules_next_phys)
			try:
				print "%20s\t virt 0x%lx\t phys 0x%lx\t core_size %d " % (modname.string(),  modules_next, modules_next_phys, core_size)
			except:
				break	
			try:
				modules_next = long(gdb.parse_and_eval("((struct module*)0x%lx).list.next" % modules_next_phys))
			except:
				break
lsmod()

