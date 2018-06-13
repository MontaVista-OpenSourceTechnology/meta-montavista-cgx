# gdb macros for extracting an LTT trace from a kernel coredump
# Copyright (C) 2014  Montavista Software <source@mvista.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA


# The layout of the LTT buffers in memory is rather complex.  But here's
# the data structures involved:
#
# sessions - a list of running sessions of type struct lttng_session.
# A session consists of a some generic information and a list of
# channels for the session.
#
# session->chan - a list of channels of type struct lttng_channel.  The
# main information of interest is in chan.backend.
#
# This code parses the sessions and channels until it finds the first
# active non-metadata session/channel running in snapshot
# (relay-overwrite-mmap) mode.
#
# The chan.backend has some useful information about data sizes and a
# percpu array of ring buffers.  Each CPU logs to its ring buffer and
# the downstream tools pull all the data together.  The dump process
# creates a separate file for each CPU, just like the normal tools do.
#
# chan.backend->buf - A percpu array of structures of type struct
# lib_ring_buffer.  This is more or less the heart of the data
# structure.  Like channels, lib_ring_buffer has a backend field that
# holds most of the useful data.
#
# buf->backend.array - An array of pointers to subbuffers.  A
# subbuffer itself is an array of pointers to pages, and each page in
# order holds data.  LTT elements do not span subbuffers, so the
# actual size of the data in the subbuffer may be smaller than the
# full subbuffer size.  subbuf->data_size holds the actual data size in
# the subbuffer.
#
# buf->backend.buf_wsb - The subbuffers may not be in order.  This array
# holds the order of the subbuffers.
#
# chan->backend.num_subbuf - The number of subbuffers.
#
# chan->backend.subbuf_size - The size of each subbuffer, in bytes.
#
# So at this point, you can trace down any index by taking the index,
# dividing it by num_subbuf to get the subbuffer, taking that and
# doing a modulo on num_subbuf(*), indexing into buf->backend.buf_wsb
# to get the actual subbuffer number, then indexing into
# buf->backend.array to get a pointer to the subbuffer.  Then take the
# original index, modulo it by the number of subbuffers to get a
# subbuffer offset.  Dividing the subbuffer offset by the number of
# pages in a subbuffer gives the page in the subbuffer, and modulo the
# subbuffer offset by the page size to get the offset into the page.
# The page data structure has a virtual pointer so the data can be
# directly accessed.
#
# (*) the offset and consumed values do not wrap at the total output size,
# so you must modulo the subbuffer index to get the proper value.
#
# buf->offset - The index of the end of the data.
# buf->consumed - The index to the start of data.
#
# So the basic algorithm is to index down to buf->consumed and start dumping
# pages until buf->offset is reached.
#
# The command is invoked as:
#    dumpltt <lttdir> <outputdir>
# where lttdir is the place where the ltt modules are compiled and outputdir
# is the place where you want to put the trace output.
#
# The lttdir is required because this code loads the symbol tables
# from the ltt modules so it can access the various data structures in
# ltt.  It will not work without that.


import os

def calc_offset(struct, member):
    """Calculate the offset in the struct to the given member."""
    return gdb.parse_and_eval("((int)&((%s *)0).%s)" % (struct, member))

def fetch_container(ptr, struct, lmember):
    """Fetch a pointer to the given structure given a pointer to one of
    its members.  This is generally used to get the container of a list
    element."""
    offset = calc_offset(struct, lmember)
    s = gdb.parse_and_eval("(void *) (((unsigned long) %s) - %s)" %
                          (ptr, offset))
    return "((%s *) %s)" % (struct, s)

def get_ptr(ptr, struct):
    """Return a string that can be used to reference the given type (struct)
    at the given address (ptr)."""
    s = gdb.parse_and_eval("(void *) %s" % ptr)
    return "((%s *) %s)" % (struct, s)
    
def get_str(p):
    """Get a string value from the given target address"""
    s = gdb.parse_and_eval("(char *) %s" % p)
    return str(s).split('"')[1]

def align(v, alignment):
    """Align the given integer to the given alignment"""
    return (v + (alignment - 1)) & ~(alignment - 1)

def get_file_size(fname):
    """Return the size of the given file"""
    f = open(fname, "a")
    size = f.tell()
    f.close()
    return size

def value_to_binary(tmpdir, typestr, v):
    """Convert an expression to a binary value.  The size depends
    on the typestr given.  Return a string with the raw binary value
    in target-endian order"""
    fn = "%s/dummy" % tmpdir
    gdb.execute("append value %s ((%s) %ld)" % (fn, typestr, int(v)))
    f = open(fn, "rb")
    str = f.read()
    f.close()
    os.unlink(fn)
    return str

littleendian = None
def is_little_endian():
    global littleendian
    if littleendian is None:
        littleendian = 'little' in gdb.execute("show endian", to_string=True)
    return littleendian
    
def read_value(f, typestr):
    """Read a value from a file.  The size depends
    on the typestr given.  Return an integer."""
    tsize = int(gdb.parse_and_eval("sizeof(%s)" % typestr))
    vs = bytearray(f.read(tsize))
    if is_little_endian():
        vs = reversed(vs)
    v = 0
    for c in vs:
        v = (v << 8) | c
    return v

def get_cpu_list():
    """Return a list of online CPUs on the target."""
    try:
        ulongsize = int(gdb.parse_and_eval("sizeof(unsigned long)"))
        nr_cpumask = int(gdb.parse_and_eval("sizeof(__cpu_online_mask)"))
        nr_cpumask = int(nr_cpumask / ulongsize)
        cpu = 0;
        cpus = []
        for i in range(0, nr_cpumask):
            mask = int(gdb.parse_and_eval("__cpu_online_mask.bits[%d]" % i))
            for j in range(0, ulongsize * 8):
                if ((mask & 1) != 0):
                    cpus.append(cpu)
                mask = mask >> 1
                cpu = cpu + 1
    except:
        print("***Unable to get number of CPUs, defaulting to 1")
        cpus = [ 0 ]
    return cpus

def get_percpu_ptr(p, cpu, typename):
    """Convert a percpu pointer 'p' on the given cpu to a pointer to the
    given type."""
    try:
        offset = gdb.parse_and_eval("__per_cpu_offset[%d]" % cpu)
    except:
        offset = "0";
    v = gdb.parse_and_eval("(void *) %s + %s" % (p, offset))
    return "((%s *) %s)" % (typename, v)

def get_member_ptr(p, membtype, member):
    """Given a pointer to a structure, get the given member as a pointer
    to another structure."""
    v = gdb.parse_and_eval("%s->%s" % (p, member))
    return "((%s *) %s)" % (membtype, str(v))

def get_member_unsigned_long(p, member):
    """Given a pointer to a structure, get the given member that is an
    integer."""
    v = gdb.parse_and_eval("(unsigned long) (%s->%s)" % (p, member))
    return int(v)

def find_module(modname):
    """Return a pointer to the given module name's data structure"""
    offset = gdb.parse_and_eval("((int)&((struct module *)0).list)")
    head = gdb.parse_and_eval("modules").address
    head = head.cast(gdb.lookup_type("unsigned long"))
    current = gdb.parse_and_eval("((struct list_head *) %s)->next" % head)
    while (current != head):
        modp = gdb.parse_and_eval("((struct module *) (((char *) %s) - %s))"
                                  % (current, offset))
        modp = "((struct module *) %s)" % modp
        cname = get_str("%s->name" % modp)
        if (cname == modname):
            return modp
        current = gdb.parse_and_eval("((struct list_head *) %s)->next" %
                                     current)
    return None        

sections_needed = { ".data", ".text", ".bss" }

def find_and_load_module(symfile, modname):
    modp = find_module(modname)
    if (modp is None):
        raise gdb.GdbError("Unable to find lttng_tracer module, are you "
                           "sure lttng is loaded in this kernel dump?")
    sect_strs = []
    sect_count = gdb.parse_and_eval("%s->sect_attrs->nsections" % modp)
    textaddr = 0
    for i in range(0, int(sect_count)):
        name = get_str("%s->sect_attrs->attrs[%d].name" % (modp, i))
        if (name in sections_needed):
            addr = gdb.parse_and_eval("%s->sect_attrs->attrs[%d].address"
                                      % (modp, i))
            if (name == ".text"):
                textaddr = addr
            else:
                sect_strs.append("-s %s %s" % (name, addr))
    if (textaddr == 0):
        raise gdb.GdbError("No .text address for module %s" % modname)
    gdb.execute("add-symbol-file %s %s %s" %
                (symfile, textaddr, " ".join(sect_strs)))

class dumpltt(gdb.Command):
    """Dump an LTT coredump from the kernel image."""
    def __init__(self):
        super(dumpltt, self).__init__("dumpltt", gdb.COMMAND_USER)

    def find_channel(self, head):
        """Find a channel in the list that is a per-cpu channel that
        is in snapshot mode (relay-overwrite-mmap) and return the
        first one found or None if not found."""
        p = gdb.parse_and_eval("((struct list_head *) %s)->next" % head)
        while (p != head):
            chan = fetch_container(p, "struct lttng_channel", "list")
            enabled = gdb.parse_and_eval("%s->enabled" % chan)
            if (int(enabled)):
                chantype = gdb.parse_and_eval("%s->channel_type" % chan)
                if (chantype == self.PER_CPU_CHANNEL):
                    backend = gdb.parse_and_eval("&(%s->chan->backend)" % chan)
                    backend = "((struct channel_backend *) %s)" % str(backend)
                    tpname = get_str("%s->name" % backend)
                    if (tpname == "relay-overwrite-mmap"):
                        return backend
            p = gdb.parse_and_eval("((struct list_head *) %s)->next" % p)
        return None

    def find_session_channel(self):
        """Search the channels in the given session for one in snapshot
        mode."""
        head = gdb.parse_and_eval("&sessions")
        p = gdb.parse_and_eval("sessions.next")
        while (p != head):
            session = fetch_container(p, "struct lttng_session", "list")
            active = gdb.parse_and_eval("%s->active" % session)
            if (int(active)):
                chanlist = gdb.parse_and_eval("&(%s->chan)" % session)
                chan = self.find_channel(chanlist)
                if (chan is not None):
                    return (session, chan)
            p = gdb.parse_and_eval("((struct list_head *) %s)->next" % p)
        return (None, None)

    def add_alignment (self, cpu, size):
        """Dump 'size' bytes to the per-CPU output file."""
        f = open("%s/channel0_%d" % (self.dumpdir, cpu), "ab")
        f.write(bytes(size))
        f.close()
        return

    def dump_page(self, cpu, page, start, size):
        """Dump 'size' bytes from the page starting at offset 'start'
        to the per-CPU output file."""
        if (size == 0):
            return
        addr = int(gdb.parse_and_eval("%s->virt" % page)) + start
        end = addr + size
        gdb.execute("append memory %s/channel0_%d %ld %ld" %
                    (self.dumpdir, cpu, addr, end))
        return

    def dump_subbuffer(self, cpu, rbbep, start, size):
        """Dump 'size' bytes from offset 'start' in the given subbuffer
        'rbbep' to the per-CPU output file."""
        start_page = int(start / self.page_size)
        start_offset = int(start % self.page_size)
        written = 0
        for i in range(start_page, int(self.num_pages_per_subbuf)):
            bepage = get_ptr("&(%s->p[%d])" % (rbbep, i),
                             "struct lib_ring_buffer_backend_page")
            if (size > self.page_size - start_offset):
                self.dump_page(cpu, bepage, start_offset,
                               self.page_size - start_offset)
                size -= self.page_size - start_offset
                written += self.page_size - start_offset
                start_offset = 0
            else:
                self.dump_page(cpu, bepage, start_offset, size)
                written += size
                break
        return written

    def recalc_end_tsc(self, begin_tsc):
        ulongsize = gdb.parse_and_eval("sizeof(unsigned long)")
        if (ulongsize == 8):
            # last_tsc is not truncated, just return.
            return self.last_tsc
        return (begin_tsc & 0xffffffff00000000) | self.last_tsc

    def handle_subbuffer(self, cpu, buf, rbbe, cidx, coffset, length):
        """Extract necessary information from the subbuffer and dump it to a
        file.

        buf is the ring buffer.
        rbbe is a pointer to the buf->backend.buf_wsb array.
        cidx is the subbuffer index (for indexing into cidx).
        coffset is the offset within the subbuffer to start at.
        length is the number of bytes to dump from the subbuffer.

        Note that each subbuffer has a header, and it may not be
        completely filled out.  So add the subbuffer size and
        the size padded to a page to the header after writing it
        out.  Plus fix the timestamp if it has not been set yet.
        """
        sid = int(gdb.parse_and_eval("%s[%d].id" % (rbbe, cidx)))
        sbidx = sid & self.idmask
        rbbep = get_ptr("%s->backend.array[%d]" % (buf, sbidx),
                        "struct lib_ring_buffer_backend_pages")
        size = get_member_unsigned_long(buf, "commit_hot[%d].seq.v" % (cidx))
        if ((size & (self.subbuf_size - 1)) == 0):
            # Hot value is a multiple of the subbuffer size, use the
            # buffer data size.
            size = int(gdb.parse_and_eval("%s->data_size" % rbbep))
        else:
            size = size % self.subbuf_size
        last_subbuf_start = get_file_size("%s/channel0_%d"
                                          % (self.dumpdir, cpu))
        if (length > 0 and length < size):
            size = length
        if (size == 0):
            return
        written_size = self.dump_subbuffer(cpu, rbbep, coffset, size);
        padded_size = align(written_size, self.page_size)
        self.add_alignment(cpu, padded_size - written_size)

        print("    subbuf size = %d (pad %d) %d" % (padded_size,
                                                    padded_size - written_size,
                                                    size))
        
        # Now fix the values in the header
        f = open("%s/channel0_%d" % (self.dumpdir, cpu), "r+b")

        # End timestamp
        f.seek(last_subbuf_start + 40, os.SEEK_SET)
        end_tsc = read_value(f, "uint64_t")
        if (end_tsc == 0):
            # It's the last packet, just hack it to the max possible value.
            end_tsc = 0xffffffffffffffff
            f.seek(last_subbuf_start + 40, os.SEEK_SET)
            val = value_to_binary(self.dumpdir, "uint64_t", end_tsc)
            f.write(val)

        # content size
        f.seek(last_subbuf_start + 48, os.SEEK_SET)
        val = value_to_binary(self.dumpdir, "uint64_t", written_size * 8)
        f.write(val)

        # packet size.
        f.seek(last_subbuf_start + 56, os.SEEK_SET)
        val = value_to_binary(self.dumpdir, "uint64_t", padded_size * 8)
        f.write(val)
        f.close()

    def handle_buffer(self, cpu, buf):
        """Dump the given ring buffer to the given cpu's output file."""
        print("Handling cpu %d buffer %s" % (cpu, buf))
        offset = int(gdb.parse_and_eval("%s->offset.v" % buf))
        oidx = int((offset / self.subbuf_size) % self.num_subbuf)
        ooffset = int(offset % self.subbuf_size)
        consumed =  int(gdb.parse_and_eval("%s->consumed.counter" % buf))
        cidx = int((consumed / self.subbuf_size) % self.num_subbuf)
        coffset = int(consumed % self.subbuf_size)
        rbbe = get_ptr("%s->backend.buf_wsb" % buf,
                       "struct lib_ring_buffer_backend_subbuffer")
        subbuf_num = 1;
        while (oidx != cidx):
            print("  subbuffer %d" % subbuf_num)
            self.handle_subbuffer(cpu, buf, rbbe, cidx, coffset, 0)
            cidx = int((cidx + 1) % self.num_subbuf)
            coffset = 0
            subbuf_num += 1
        
        print("  subbuffer %d" % subbuf_num)
        self.handle_subbuffer(cpu, buf, rbbe, cidx, coffset, ooffset - coffset)
        return

    def dump_metadata(self, session):
        f = open("%s/metadata" % (self.dumpdir), "w")
        f.write("/* CTF 1.8 */\n")
        f.close()
        mdcache = get_member_ptr(session, "struct lttng_metadata_cache",
                                 "metadata_cache")
        data = get_member_unsigned_long(mdcache, "data")
        size = get_member_unsigned_long(mdcache, "metadata_written")
        gdb.execute("append memory %s/metadata %ld %ld" %
                    (self.dumpdir, data, data + size))
        
    def invoke(self, args, from_tty):
        argv = gdb.string_to_argv(args)
        if (len(argv) != 2):
            raise gdb.GdbError("dumpltt <lttdir> <dumpdir>")

        lttdir = argv[0]
        self.dumpdir = argv[1]
        os.system("mkdir -p %s" % self.dumpdir)
        os.system("rm -rf %s/channel*" % self.dumpdir)
        os.system("rm -rf %s/dummy" % self.dumpdir)

        find_and_load_module("%s/lttng-tracer.o" % lttdir, "lttng_tracer")
        find_and_load_module("%s/lib/lttng-lib-ring-buffer.o" % lttdir,
                             "lttng_lib_ring_buffer")

        self.PER_CPU_CHANNEL = gdb.parse_and_eval("PER_CPU_CHANNEL")

        (session, backend) = self.find_session_channel()
        if (backend is None):
            raise gdb.GdbError("Unable to find operating session, are you sure "
                               "lttng was running with --snapshot?")
        self.dump_metadata(session)
        self.num_subbuf = int(gdb.parse_and_eval("%s->num_subbuf" % backend))
        self.subbuf_size = int(gdb.parse_and_eval("%s->subbuf_size" % backend))
        self.config = get_ptr("&(%s->config)" % backend,
                              "struct lib_ring_buffer_config")
        self.tsc_bits = int(gdb.parse_and_eval("%s->tsc_bits" % self.config))
        p = get_percpu_ptr("%s->buf" % backend, 0, "struct lib_ring_buffer")
        self.last_tsc = int(gdb.parse_and_eval("%s->last_tsc.v" % p))
        self.num_pages_per_subbuf = int(gdb.parse_and_eval(
            "%s->backend.num_pages_per_subbuf" % p))
        self.page_size = int(self.subbuf_size / self.num_pages_per_subbuf)
        self.idshift = int(int(gdb.parse_and_eval("sizeof(long)")) * 8 / 2)
        self.idmask = (1 << self.idshift) - 1
        cpus = get_cpu_list()
        for cpu in cpus:
            p = get_percpu_ptr("%s->buf" % backend, cpu,
                               "struct lib_ring_buffer");
            self.handle_buffer(cpu, p)

dumpltt()
