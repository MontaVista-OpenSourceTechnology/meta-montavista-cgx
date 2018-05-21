# emit_shellscript.inc
#
# Copyright (c) 2009 MontaVista Software, Inc.  All rights reserved.
#
# Released under the MIT license (see LICENSE.MIT for the terms)

#
# Emits a shell script to EMIT_SHELLSCRIPT_FN containing a #!/bin/sh and
# exported variable definitions for all the variables in EMIT_SHELLSCRIPT_VARS
# from the bitbake configuration metadata.  The emission occurs when the
# ConfigParsed event fires, which is when bitbake finishes parsing of the
# configuration metadata, so this will get emitted even if you aren't
# doing a build.  EMIT_SHELLSCRIPT_VARS_WEAK are special.  They're set in in
# the script only if they aren't already set, and they get replaced with
# variable references in the values of the vars from EMIT_SHELLSCRIPT_VARS.
#
# Also now emits a shell script to EMIT_SHELLSCRIPT_KFN containing the
# shell variable definitions needed for building the linux kernel.

inherit kernel-maparch

EMIT_SHELLSCRIPT_FN ?= "${TOPDIR}/bin/${MLPREFIX}env.sh"
EMIT_SHELLSCRIPT_KFN ?= "${TOPDIR}/bin/kenv.sh"
EMIT_SHELLSCRIPT_VARS_WEAK += "TOPDIR"
EMIT_SHELLSCRIPT_VARS += "STAMP CC CXX F77 CPP LD CCLD AR AS RANLIB STRIP OBJCOPY OBJDUMP NM"
EMIT_SHELLSCRIPT_VARS += "CFLAGS CPPFLAGS CXXFLAGS LDFLAGS"
EMIT_SHELLSCRIPT_VARS += "TARGET_PREFIX MVL_SDK_PREFIX TARGET_ARCH TARGET_CC_ARCH"
EMIT_SHELLSCRIPT_VARS += "STAGING_DIR_HOST PATH EXTERNAL_TOOLCHAIN CONFIGUREOPTS"
EMIT_SHELLSCRIPT_VARS += "GNUCONFIGIZE AUTOMAKE ACLOCAL perllibdir"
EMIT_SHELLSCRIPT_VARS += "autom4te_perllibdir AUTOHEADER AUTOCONF"
EMIT_SHELLSCRIPT_VARS += "AUTOM4TE AC_MACRODIR M4 LIBTOOL PATH"
EMIT_SHELLSCRIPT_VARS += "PKG_CONFIG_SYSROOT_DIR PKG_CONFIG_PATH PKG_CONFIG_DIR"
EMIT_SHELLSCRIPT_VARS += "PKG_CONFIG_DISABLE_UNINSTALLED"
EMIT_SHELLSCRIPT_VARS += "MACHINE EXPORT_ADK_CONFIGURE CONFIGURE_FLAGS"
CFGSIGBLACKLIST += "EMIT_SHELLSCRIPT_FN EMIT_SHELLSCRIPT_VARS emit_shellscript_eh"

def print_exception(e, msgbase, domain='default'):
    """ Prints information about an exception, prefixed by msgbase.
    It includes a traceback, only if bitbake debugging is enabled. """

    from traceback import print_exc
    from bb import error
    from bb.msg import debug_level

    if debug_level[domain]:
        error("%s:" % msgbase)
        print_exc(3)
    else:
        error("%s:\n%s" % (msgbase, e))

def emit_shellscript(fn, d):
    """ Write a shell script to fn containing definitions of the supplied
    variables from the supplied bitbake datastore. """

    from bb.utils import mkdirhier
    from bb import note
    from os.path import dirname
    from pipes import quote

    mkdirhier(dirname(fn))

    f = open(fn, "w")
    f.write("#!/bin/sh\n")
    standalone = d.getVar("STANDALONE_SYSROOT")
    standalone_native = d.getVar("STANDALONE_SYSROOT_NATIVE")
    staging_dir_host = d.getVar("STAGING_DIR_HOST")
    staging_dir_native = d.getVar("STAGING_DIR_NATIVE")
    def emit(var, val, weak = False):
        # If the value isn't a string, or the variable name is one that shell
        # will choke on, skip this variable.
        if not isinstance(val, str) or \
           var != quote(var) or \
           var.find("-") != -1:
           note("emit_shellscript: skipping emission of %s (%s)" % (var, val))
           return
        setvar = "export %s=\"%s\"\n" % (var, val)
        if weak:
            f.write("if test -z \"${%s}\"; then\n" % var)
            f.write("    " + setvar)
            f.write("fi\n")
        else:
            f.write(setvar)

    # Courtesy the fine folks in #python on freenode
    def unique(iterable):
        seen = set()
        for x in iterable:
            if x not in seen:
                yield x
                seen.add(x)

    weakvars = tuple(unique(d.getVar("EMIT_SHELLSCRIPT_VARS_WEAK", 1).split()))
    for wvar in weakvars:
        wval = d.getVar(wvar, 1)
        emit(wvar, wval, True)

    for var in unique(d.getVar("EMIT_SHELLSCRIPT_VARS", 1).split()):
        val = d.getVar(var, 1) or ""
        val = val.replace(staging_dir_native, standalone_native)
        val = val.replace(staging_dir_host, standalone)
        if var == "PATH":
           val = val + ":$PATH"
        # Assign CONFIGURE_FLAGS with CONFIGUREOPTS values
        if var == "CONFIGURE_FLAGS":
           val = d.getVar("CONFIGUREOPTS", 1) or ""
        if var == "STAMP":
           val = os.path.dirname(val)
        if val:
           for wvar in weakvars:
              wval = d.getVar(wvar, 1) or ""
              val = val.replace(wval, "${%s}" % wvar)
           emit(var, val)
        if var == "STAMP":
           f.write("if [ ! -d $STAMP ] ; then\n")
           f.write("   echo -n 'In order to use this file, you need to do an image build and '\n")
           f.write("   echo 'run \"bitbake " + d.getVar("PN") + "\"'\n")
           f.write("   return 1\nfi\n")
    f.close()
def emit_kernel_shellscript(fn, d):
    """ Write a shell script to fn containing variable definitions
    needed by the linux kernel Makefile. """

    from bb.utils import mkdirhier
    from os.path import dirname 

    mkdirhier(dirname(fn))
    standalone = d.expand("${STAGING_DIR}/${MACHINE}")
    standalone_native = d.expand("${STAGING_DIR}/${BUILD_ARCH}")
    staging_dir_host = d.getVar("STAGING_DIR_HOST")
    staging_dir_native = d.getVar("STAGING_DIR_NATIVE")
    stamp = d.getVar("STAMP")
    buildsysroot = os.path.dirname(os.path.dirname(stamp)) + "/build-sysroots"
    topdir = d.getVar("TOPDIR")
    buildsysroot = buildsysroot.replace(topdir, "${TOPDIR}")
    target_arch = d.getVar("TARGET_ARCH", 1) or ""
   
    f = open(fn, "w")
    f.write("#!/bin/sh\n\n")
    f.write("if [ -z ${TOPDIR} ] ; then\n")
    f.write("   TOPDIR=" + topdir + "\n")
    f.write("fi\n")
    
    f.write("BUILD_SYSROOT_STAMP=\"" + buildsysroot + "\"\n") 
    f.write("if [ ! -d $BUILD_SYSROOT_STAMP ] ; then\n")
    f.write("   echo -n 'In order to use this file, you need to do a kenrel(linux-mvista) build and '\n")
    f.write("   echo 'run \"bitbake build-sysroots\"'\n")
    f.write("   return 1\nfi\n")
    msd = d.getVar("MSD", 1) or ""
    f.write("# Export kernel Makefile variables for %s.\n\n" % msd)

    arch = map_kernel_arch(target_arch, d)
    f.write('export ARCH="%s"\n' % arch)

    kcflags = d.getVar("TARGET_CC_KERNEL_ARCH", 1)
    if not kcflags:
        kcflags = d.getVar("TARGET_CC_ARCH", 1) or ""
    kernelcc = d.getVar("KERNEL_CC", 1) or ""
    kernelcc = kernelcc.replace(staging_dir_host,standalone).replace(topdir, "${TOPDIR}")
    kernelld = d.getVar("KERNEL_LD", 1) or ""
    kernelld = kernelld.replace(staging_dir_host,standalone).replace(topdir, "${TOPDIR}")
    kernelar = d.getVar("KERNEL_AR", 1) or ""
    kobjdump = d.getVar("OBJCOPY", 1) or ""
    kcrosscompile= d.getVar("CROSS_COMPILE", 1) or ""
    kernelextra = d.getVar("KERNEL_EXTRA_ARGS", 1) or ""
    kerneltarget = d.getVar("KERNEL_IMAGETYPE", 1) or ""
    f.write('export KERNEL_CC="%s"\n' % kernelcc)
    f.write('export KERNEL_LD="%s"\n' % kernelld)
    f.write('export KERNEL_EXTRA_ARGS="%s"\n' % kernelextra)
    f.write('export KERNEL_IMAGETYPE="%s"\n' % kerneltarget)
    f.write('export KERNEL_AR="%s"\n' % kernelar)
    f.write('export CROSS_COMPILE="%s"\n' % kcrosscompile)
    f.write('export OBJDUMP="%s"\n' % kobjdump)
    
    f.write('export LDFLAGS=\n')

    target_prefix = d.getVar("TARGET_PREFIX", 1) or ""
    f.write('export CROSS_COMPILE="%s"\n' % target_prefix)
    path = d.getVar("PATH")
    path = path.replace(staging_dir_native, standalone_native).replace(topdir, "${TOPDIR}")
    path = path.replace(staging_dir_host,standalone).replace(topdir, "${TOPDIR}")
    f.write('export PATH=' + path + ':$PATH')
    f.close()

python emit_shellscript_eh () {
    from bb.event import ConfigParsed, RecipeParsed
    var=None

    if isinstance(e, RecipeParsed) and bb.data.inherits_class('kernel',e.data):
       var="EMIT_SHELLSCRIPT_KFN"
       script=emit_kernel_shellscript

    if isinstance(e, RecipeParsed) and not bb.data.inherits_class('native', e.data):
       if e.data.getVar("BPN") == "build-sysroots":
          var="EMIT_SHELLSCRIPT_FN"
          script=emit_shellscript

    if var:
       fn = e.data.getVar(var, 1) or ""
       try:
          script(fn, e.data)
       except (IOError, OSError) as e:
          print_exception(e, "emit_shellscript: unable to emit vars into %s" % fn)
          raise SystemExit()
}
addhandler emit_shellscript_eh
