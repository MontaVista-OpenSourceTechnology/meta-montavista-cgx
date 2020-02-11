#!/usr/bin/env python3
#
#    mvinstaller - Installer tool for MV Linux
#    Copyright (C) 2014  MontaVista Software, LLC
#
# Modified BSD Licence
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#   1. Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#   2. Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#   3. The name of the author may not be used to endorse or promote
#      products derived from this software without specific prior
#      written permission.


import sys
import subprocess
import os
import os.path
import traceback
import stat
import readline
import time
import re

efi_system = False

try:
    if stat.S_ISDIR(os.stat("/sys/firmware/efi").st_mode):
        efi_system = True
        pass
    pass
except:
    pass

class InstallerException(Exception):
    """Raised by the installer when it cannot continue an operation"""
    pass

def uuid_to_dev(uuid):
    """Given a "UUID=xxxx" in uuid, find the actual /dev/... device"""
    p = subprocess.Popen(("blkid", "-t", uuid), stdin=None,
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (out, err) = p.communicate()
    if (p.returncode):
        print("Error converting %s to a device: %s" % (uuid, err))
        raise InstallerException()
    (dev, rest) = out.split(":", 1)
    return dev

def find_base_devices(dev):
    """Takes a device and finds all devices that underly it.  dev may be
    an LVM device, an MD (RAID) device, a partition, or a device itself.
    This program will trace down and return a list of all disk device
    (like /dev/sda, /dev/sdb, etc.) that the given device sits upon.
    """
    if (dev.startswith("UUID=")):
        dev = uuid_to_dev(dev)
    elif not dev.startswith("/dev/"):
        print("Error: device %s doesn't start with /dev/" % dev)
        raise InstallerException()

    base = dev[5:]
    subdevs = []
    if (base.startswith("md")):
        f = open("/proc/mdstat")
        for l in f:
            w = l.split()
            if (len(w) < 5):
                continue
            if (w[0] != base):
                continue
            for d in w[4:]:
                (d, rest) = d.split("[", 1)
                subdevs += find_base_devices("/dev/" + d)
                pass
            break
            pass
        f.close()
        pass
    elif (base.startswith("mapper/")):
        (vgname, lvname) = base[7:].split('-', 1)
        v = subprocess.Popen(("pvs", "--noheadings"), stdin=None,
                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        (out, err) = v.communicate()
        if (v.returncode != 0):
            print("Error: pvs command returned: " + err)
            raise InstallerException()
        lines = out.split("\n")
        for l in lines:
            w = l.split()
            if (len(w) < 2):
                continue
            if (w[1] != vgname):
                continue
            subdevs += find_base_devices(w[0])
            pass
        pass
    elif (base.startswith("sd") or base.startswith("hd")):
        subdevs = [ "/dev/" + base[0:3], ]
    else:
        print(("Error: Device %s is not understood by this installer.  It can"
               % dev))
        print("handle /dev/md..., /dev/[hs]d..., and /dev/mapper/...")
        raise InstallerException()

    return subdevs

class CmdErr(Exception):
    def __init__(self, cmd, returncode, out, errout):
        self.cmd = cmd
        self.returncode = returncode
        self.out = out
        self.errout = errout
        return

    def __str__(self):
        return ("Error %d:%s\n%s\n%s"
                % (self.returncode, self.cmd, self.out, self.errout))

    pass

def _call_cmd(cmd, ignerr=False):
    prog = subprocess.Popen(cmd,
                            stdin=None, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, close_fds=True)
    (out, err) = prog.communicate()
    if (not ignerr and prog.returncode != 0):
        raise CmdErr(str(cmd), prog.returncode, out, err)
    return out
    
# Default unit is sectors
def _call_parted(dev, cmds):
    cmd = ["parted", "-ms", "--align=opt", "--", dev] + cmds
    prog = subprocess.Popen(cmd,
                            stdin=None, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, close_fds=True)
    (out, err) = prog.communicate()
    if (prog.returncode != 0):
        raise CmdErr(str(cmd), prog.returncode, out, err)
    return out
    
def _call_mdadm(dev, cmd, opts, ignerr=False):
    return _call_cmd(["mdadm", cmd, dev] + opts, ignerr=ignerr)

def _call_lvmcmd(cmd, opts = []):
    cmd = [cmd, ] + opts
    prog = subprocess.Popen(cmd,
                            stdin=None, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, close_fds=True)
    (out, err) = prog.communicate()
    if (prog.returncode != 0):
        raise CmdErr(str(cmd), prog.returncode, out, err)
    return out

def _call_lvmdispcmd(cmd, opts = []):
    opts = ["--noheadings", "--nosuffix"] + opts
    return _call_lvmcmd(cmd, opts)

class ReadlineDefVal:
    def __init__(self, value):
        self.v = value
        return

    def hook(self):
        readline.insert_text(self.v)
        return

    def setvalue(self, value):
        self.v = value
        return

    pass

class Installer:
    """The installer class, used to partition and install a system.
    This may be used for interactive or automated installs.
    """

    # A hash of all mounts from /tmp/fstab.  This is a hash of
    # "mount_point : info", the mount point is like /home, /boot, etc.
    # The info is another has containing "dev", "type", and "opts" for
    # the device to mount, the filesystem type, and the filesystem options.
    mounts = {}

    # The prefix where the filesystems to be installed sit.
    mpref = "/t"

    # Has mpref been installed yet?
    installed = False

    # A list of all devices in the system.
    alldevs = []

    # A hash of special mount points required for installation
    smounts = { "/dev" : { "dev" : "none", "type" : "tmpfs", "opts" : None },
                "/proc" : { "dev" : "none", "type" : "proc", "opts" : None },
                "/sys" : { "dev" : "none", "type" : "sysfs", "opts" : None } }

    # A list of filesystem types to ignore when reading in a fstab.
    ignore_fs_types = ( "proc", "tmpfs", "devpts", "usbfs", "auto", "swap" )

    def __init__(self):
        self.read_devs()
        return

    def read_devs(self, start=True):
        """Get a list of all devices in the system and put it in alldevs"""

        # Make sure mdadm and lvm is up to date
        _call_cmd(("vgchange", "-a", "n"), ignerr=True)
        _call_cmd(("mdadm", "--stop", "--scan"), ignerr=True)
        if (start):
            _call_cmd(("mdadm", "--assemble", "--scan", "--run"), ignerr=True)
            _call_cmd(("vgscan",), ignerr=True)
            _call_cmd(("vgchange", "-a", "y"), ignerr=True)
            pass

        avail = open("/proc/diskstats")
        devs = []
        for l in avail:
            w = l.split()
            if (w[2].startswith("sd") or w[2].startswith("hd")):
                devs.append("/dev/" + w[2])
            elif (w[2].startswith("md")):
                devs.append("/dev/" + w[2])
                pass
            pass
        avail.close()
        p = subprocess.Popen(("lvs", "--noheadings", "--nosuffix"),
                             stdin=None, stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, close_fds=True)
        (out, err) = p.communicate()
        out = out.split("\n")
        for l in out:
            w = l.split()
            if (not w):
                continue
            devs.append("/dev/" + w[1] + "/" + w[0])
            pass
        self.alldevs = devs
        return

    def get_vgs(self):
        """Return a list of all volume groups in the system."""
        vgs = []
        vgl = _call_lvmdispcmd("vgs").split('\n')
        for l in vgl:
            w = l.split()
            if (not w):
                continue
            vgs.append(w[0])
            pass
        return vgs

    def clean_vgs(self):
        for v in self.get_vgs():
            print("Removing volume group " + v)
            _call_lvmcmd("vgremove", ["--force", v])
            pass
        return

    def clean_system(self):
        """Stop all RAIDs and logical volumes and remove all volume groups.
        Note that this does not delete partitions.
        """
        self.unmount_all()
        self.clean_vgs()
        self.read_devs(start=False)
        return
        
    def unmount(self, m):
        """Unmount a mount point in mpref"""
        subprocess.call(("umount", self.mpref + m))
        return

    def unmount_all(self):
        """Unmount all mount points in self.mounts, and smounts"""
        if (not self.mounts):
            # Haven't read the partition table in, nothing to do.
            return
        for i in self.smounts:
            self.unmount(i)
            pass
        keys = list(self.mounts.keys())
        keys.sort(reverse=True)
        for k in keys:
            self.unmount(k)
            pass
        return

    def mount(self, m, dev, t=None, opts=None):
        """Mount a given filesystem (m) with the given device.  The filesystem
        type and options are given in t and opts.
        """
        subprocess.call(("mkdir", "-p", self.mpref + m))
        call = ["mount",]
        if (t):
            call.append("-t")
            call.append(t)
            pass
        if (opts):
            call.append("-o")
            call.append(opts)
            pass
        call.append(dev)
        call.append(self.mpref + m)
        return subprocess.call(call)

    def copy_dev(self):
        subprocess.call(["cp -a /dev/* " + self.mpref + "/dev"], shell=True)
        return

    def mount_all(self):
        """Mount all mount points in self.mounts, and smounts"""
        keys = list(self.mounts.keys())
        keys.sort()
        for k in keys:
            m = self.mounts[k]
            self.mount(k, m["dev"], m["type"], m["opts"])
            pass
        for k in self.smounts:
            m = self.smounts[k]
            self.mount(k, m["dev"], m["type"], m["opts"])
            pass
        self.copy_dev()
        return

    def find_boot_devices(self):
        """Return a list of all physical devices the /boot filesystem sits on.
        """
        if "/boot" in self.mounts:
            mp = "/boot"
        elif "/" in self.mounts:
            mp = "/"
        else:
            print(("Error: Could not find /boot or / in the mounts, cannot"
                   + " find boot"))
            print("devices.")
            raise InstallerException()

        devs = find_base_devices(self.mounts[mp]["dev"])

        # Remove duplicates
        devs.sort()
        i = 1
        while (i < len(devs)):
            if (devs[i-1] == devs[i]):
                del devs[i]
            else:
                i += 1
                pass
            pass

        return devs

    def partition(self):
        """Call the partitioner.  This unmounts everything first, calls
        the partitioner, then rereads the mount table and remounts everything.
        """
        self.unmount_all()
        if (os.access("/tmp/fstab", os.R_OK)):
            input_fstab = "/tmp/fstab"
        else:
            input_fstab = "/etc/fstab"
            pass

        prog = subprocess.call(("mvpartition",
                                "--output-fstab", "/tmp/fstab",
                                "--input-fstab", input_fstab))
        self.reread_fstab()
        self.mount_all()
        return

    def reread_fstab(self, tab="/tmp/fstab"):
        """Read in the given fstab and populate the mounts hash with the
        contents.
        """
        m = { }
        fstab = open(tab)
        for l in fstab:
            l = l.strip()
            if (not l):
                continue
            if (l[0] == "#"):
                continue
            w = l.split()
            if (w[2] in self.ignore_fs_types):
                continue
            m[w[1]] = {"dev" : w[0], "type" : w[2], "opts" : w[3] }
            pass
        fstab.close()

        if ("/" not in m):
            print("ERROR: / is not in the fstab, please redo the partitions and")
            print("add / as a mount point")
            raise InstallerException()
        
        if (not efi_system and "/boot" not in m):
            print("WARNING: /boot is not in the fstab. This is not an error,")
            print(" but it is generally recommended that /boot be on a")
            print(" separate partition.")
            pass

        if (efi_system and "/boot/efi" not in m):
            print("ERROR: This is an EFI system, /boot/efi must be a VFAT")
            print(" partition of 200MB.")
            raise InstallerException()

        self.mounts = m
        return

    def get_serial_parms(self, console):
        if (not console.startswith("ttyS")):
            return None

        speed = "9600"
        parity = "no"
        word = "8"
        stop = "1"
        l = console.split(",")
        if (len(l) > 1):
            w = l[1]
            i = 0
            e = len(w)
            for c in w:
                if not c.isdigit():
                    break
                i += 1
                pass
            speed = w[0:i]
            if (i < e):
                if (w[i] == "e"):
                    parity = "even"
                elif (w[i] == "o"):
                    parity = "odd"
                    pass
                i += 1
                pass
            if (i < e):
                word = w[i]
                i += 1
                pass
            if (i < e):
                stop = w[i]
                pass
            pass
        unit = l[0][4:]
        return (unit, speed, parity, word, stop)

    def set_grub_serial(self, parms):
        if (not parms):
            return
        (unit, speed, parity, word, stop) = parms
        
	if (efi_system):
	        grubdir = self.mpref + "/etc/efi-grub.d"
	else:
	        grubdir = self.mpref + "/etc/grub.d"
		pass
        fout = open(grubdir + "/01_serial", "w+")
        fout.write("""echo "insmod serial"
echo "serial --unit=%s --speed=%s --parity=%s --word=%s --stop=%s"
echo "terminal_input serial"
echo "terminal_output serial"
""" % (unit, speed, parity, word, stop))
	fout.close()
        os.chmod(grubdir + "/01_serial",
                 stat.S_IRWXU |
                 stat.S_IRGRP | stat.S_IXGRP |
                 stat.S_IROTH | stat.S_IXOTH)
        return

    def set_inittab(self, parms):
        fin = open(self.mpref + "/etc/inittab", "r")
        fout = open(self.mpref + "/etc/inittab.tmp", "w+")
        for l in fin:
            if "getty" in l:
                break
            fout.write(l)
            pass
        fin.close()
        if (parms):
            # Serial, add the serial console.
            (unit, speed, parity, word, stop) = parms
            fout.write("s%s:2345:respawn:/sbin/getty ttyS%s %s vt100\n"
                       % (unit, unit, speed))
        else:
            # Not serial, just add some normal consoles.
            for i in (1, 2, 3, 4):
                fout.write("t%d:2345:respawn:/sbin/getty tty%d 38400 linux\n"
                           % (i, i))
                pass
            pass
        fout.close()
        os.rename(self.mpref + "/etc/inittab.tmp", self.mpref + "/etc/inittab")
        return
            
    def install(self):
        """Untar the tarball in /to_install.tar.gz into mpref.  Print a
        "*" for every 10 files that are untarred.  After the files have
        been untarred, this will also do the following:
        Put /tmp/fstab into mpref/etc/fstab
        Enable checking the root filesystem in mpref/etc/default/rcS
        If a console is set in the running kernel, set it in the installed
        systems grub configuration
        """
        if (not self.mounts):
            print("You must first partition your system before installing")
            raise InstallerException()

        # We unmount /dev around the untar because we want the devices
        # there from the install.  Otherwise /dev/console and others
        # won't be there and init won't work.
        self.unmount("/dev")
        errfd = open("/tmp/tar-error", "w")
        tar = subprocess.Popen(("tar", "-C", self.mpref, "-xvzf",
                                "/to_install.tar.gz"),
                               stdout=subprocess.PIPE, stderr=errfd, stdin=None)
        count = 0
        for l in tar.stdout:
            count += 1
            if (count >= 10):
                sys.stdout.write("*")
                sys.stdout.flush()
                count = 0
                pass
            pass
        tar.wait()
        errfd.close()
        print("")
        self.mount("/dev", "none", "tmpfs")
        self.copy_dev()
        if (tar.returncode != 0):
            print("Errors processing the tar archive:")
            subprocess.call(("cat", "/tmp/tar-error"))
            return

        # Now clean things up on the filesystem

        # Set the FSTAB
        subprocess.call(("cp", "/tmp/fstab", self.mpref + "/etc/fstab"))

        # Now make sure fsck of the root filesystem is enabled.
        # Dummy loop so we can "break" to abort this operation.
        for i in range(0,1):
            try:
                fin = open(self.mpref + "/etc/default/rcS", "r")
            except:
                break
            try:
                fout = open(self.mpref + "/tmp/rcS", "w")
            except:
                fin.close()
                break
            try:
                for l in fin:
                    if (l.startswith("ENABLE_ROOTFS_FSCK=")):
                        fout.write("ENABLE_ROOTFS_FSCK=yes\n")
                    else:
                        fout.write(l)
                        pass
                    pass
                subprocess.call(("mv", self.mpref + "/tmp/rcS",
                                 self.mpref + "/etc/default/rcS"))
                pass
            finally:
                fin.close()
                fout.close()
                pass
            pass

        # If a console is specified when booting the CD, copy it to that
        # grub will pick it up.
        console = None
        serparms = None
        for i in range(0,1):
            try:
                fin = open("/proc/cmdline")
            except:
                break
            try:
                for l in fin:
                    for w in l.split():
                        if w.startswith("console="):
                            serparms = self.get_serial_parms(w[8:])
                            console = w
                            pass
                        pass
                    pass
                pass
            finally:
                fin.close()
                pass
            pass
        
	if (efi_system):
	        grubdir = self.mpref + "/etc/efi-grub.d"
	else:
	        grubdir = self.mpref + "/etc/grub.d"
		pass
        if (console and os.path.exists(grubdir)):
	    if (efi_system):
                fout = open(self.mpref + "/etc/default/efi-grub", "w+")
            else:
                fout = open(self.mpref + "/etc/default/grub", "w+")
                pass
            fout.write("\nGRUB_CMDLINE_LINUX='%s'\n" % console)
            fout.close()
            if (serparms):
                self.set_grub_serial(serparms)
                pass
            pass
        self.set_inittab(serparms)


        self.installed = True
        return

    def setup_from_existing_install(self, root=None):
        """Extract the /etc/fstab from a partition the user inputs (or root
        if supplied), read that fstab, and mount everything.
        """
        self.unmount_all()
        if (not root):
            print("Enter the device holding the root partition.  Options are:")
            for d in self.alldevs:
                print("  " + d)
                pass
            d = input("Please enter the device: ").strip()
            if (d not in self.alldevs):
                print("%s is not in the list, please enter a valid device" % d)
                raise InstallerException()
            root = d
            pass

        rc = self.mount("/", root)
        if (rc != 0):
            print("Unable to mount %s" % root)
            raise InstallerException()

        rc = subprocess.call(("cp", self.mpref + "/etc/fstab", "/tmp/fstab"))
        subprocess.call(("cp", self.mpref + "/etc/mdadm.conf",
                         "/tmp/mdadm.conf"))
        self.unmount("/")
        if (rc != 0):
            print("No /etc/fstab on %s, not a valid root partition" % root)
            raise InstallerException()
        self.installed = True
        self.reread_fstab()
        # Stop and restart LVM and RAID after we get /etc/mdadm.conf
        # from the filesystem.
        _call_cmd(("vgchange", "-a", "n"), ignerr=True)
        _call_cmd(("mdadm", "--stop", "--scan"), ignerr=True)

        _call_cmd(("mdadm", "--assemble", "--scan", "--run"), ignerr=True)
        _call_cmd(("vgscan",), ignerr=True)
        _call_cmd(("vgchange", "-a", "y"), ignerr=True)
        self.mount_all()
        return

    def get_base_devs(self):
        """Return a list of the base devices (not partitions, raids, LVMs,
        etc.)
        """
        basedevs = []
        for d in self.alldevs:
            # Eliminate all but fundamental devices
            if (d[-1:].isdigit()):
                continue
            if (d.count("/") != 2):
                continue
            basedevs.append(d)
            pass
        return basedevs

    def _read_bootdevs(self):
        """Read in the boot devices from the user, giving a default suggestion
        and a list of possible devices.
        """
        bootdevs = self.find_boot_devices()

        sys.stdout.write("Boot devices for this system appear to be: "
                         + " ".join(bootdevs))
        print()
        print("If the listed devices are correct, just press 'enter' here")
        print("If not, enter the devices holding the /boot partition, separated by")
        print("spaces.  This is generally the device that holds /boot, or")
        print("if a RAID device is /boot, all the devices.  Options are:")
        basedevs = self.get_base_devs()
        print(" ".join(basedevs))
        print()

        try:
            x = ReadlineDefVal(" ".join(bootdevs))
            readline.set_startup_hook(x.hook)
            d = input("Please press enter or enter the device(s): ").strip()
        finally:
            readline.set_startup_hook(None)
            pass
            
        d = d.split()
        for i in d:
            if (i not in basedevs):
                print(("%s is not in the list, please enter a valid device"
                       % i))
                raise InstallerException()
            pass
        return d

    def do_grub_bios(self, bootdevs):
        """Install grub on the target filesystem.  This does the base
        grub-install to put it onto the MBR of each disk, then creates the
        ramdisk and grub configuration in the target environment.
        If bootdevs is None, this will prompt the user for the boot devs.
        If bootdevs is a string, then the default list is used.  Otherwise
        bootdevs is a list of boot devices.
        """
        if (bootdevs.__class__ == "".__class__):
            bootdevs = self.find_boot_devices()
            pass
        if (bootdevs is None):
            bootdevs = self._read_bootdevs()
            pass

        for i in bootdevs:
            print("Installing grub on " + i)
            subprocess.call(("grub-install", "--root-directory=" + self.mpref,
                             i))
            pass

        # Rebuild the ramdisk and grub if both are installed, otherwise
        # just re-run grub config if it is installed.
        if (os.path.exists(self.mpref + "/usr/sbin/mv-re-grub")):
            subprocess.call(("chroot", self.mpref, "mv-re-grub"))
        elif (os.path.exists(self.mpref + "/usr/sbin/grub-mkconfig")):
            subprocess.call(("chroot", self.mpref,
                             "grub-mkconfig", "-o", "/boot/grub/grub.cfg"))
        else:
            print("***WARNING: Unable to configure grub on the target")
            pass
        return

    def do_grub_efi(self):
        """Install grub on the target filesystem.  This does the base
        grub-install to put it onto the MBR of each disk, then creates the
        ramdisk and grub configuration in the target environment.
        If bootdevs is None, this will prompt the user for the boot devs.
        If bootdevs is a string, then the default list is used.  Otherwise
        bootdevs is a list of boot devices.
        """

        if ("/boot/efi" not in self.mounts):
            print(("You must mount a VFAT filesystem of at least 200MB on"
                   + " /boot/efi"))
            raise InstallerException()

        # Create a grub EFI image in /boot/efi/EFI/grub
        subprocess.call(("chroot", self.mpref, "efi-grub-install"))
        subprocess.call(("mkdir", "-p", self.mpref + "/boot/efi/EFI/boot"))

        # Now copy it to the default location, in case the boot loader
        # on this system won't boot properly from the grub directory.
        try:
            os.stat(self.mpref + "/boot/efi/EFI/grub/grubx64.efi")
            subprocess.call(("cp", "-r",
                             self.mpref + "/boot/efi/EFI/grub/grubx64.efi",
                             self.mpref + "/boot/efi/EFI/boot/bootx64.efi"))
        except:
            pass
        try:
            os.stat(self.mpref + "/boot/efi/EFI/grub/grubia32.efi")
            subprocess.call(("cp", "-r",
                             self.mpref + "/boot/efi/EFI/grub/grubia32.efi",
                             self.mpref + "/boot/efi/EFI/boot/bootia32.efi"))
        except:
            pass

        # Copy the /boot/efi parttion to /boot/efi2 if it exists
        try:
            os.stat(self.mpref + "/boot/efi2")
            subprocess.call(("rm", "-rf", self.mpref + "/boot/efi2/*"));
            subprocess.call(("cp", "-r",
                             self.mpref + "/boot/efi",
                             self.mpref + "/boot/efi2"))
        except:
            pass

        # Rebuild the ramdisk and grub if both are installed, otherwise
        # just re-run grub config if it is installed.
        if (os.path.exists(self.mpref + "/usr/sbin/mv-re-grub")):
            subprocess.call(("chroot", self.mpref, "mv-re-grub"))
        elif (os.path.exists(self.mpref + "/usr/sbin/efi-grub-mkconfig")):
            subprocess.call(("chroot", self.mpref,
                             "efi-grub-mkconfig", "-o", "/boot/efi-grub/grub.cfg"))
        else:
            print("***WARNING: Unable to configure grub on the target")
            pass
        return

    def do_grub(self, bootdevs=None):
        if (not self.mounts):
            print("You must first partition your system before adding grub")
            raise InstallerException()
        if (not self.installed):
            print("You must first install your system before adding grub")
            raise InstallerException()

        f = open(self.mpref + "/etc/mdadm.conf", "w")
        subprocess.call(("mdadm", "--examine", "--scan"), stdout=f)
        f.close()

        if efi_system:
            self.do_grub_efi()
        else:
            self.do_grub_bios(bootdevs)
            pass
        return

    def clear_partition_table(self, dev, tabletype="msdos"):
        """Create a partition table on the device, clearing out anything
        that is there.  tabletype is either 'msdos' or 'gpt'.
        """
        _call_parted(dev, ["mktable", tabletype])
        return

    def get_partitions(self, dev):
        """Get a list of the partitions on the device.  A list of
        lists is returns, there is one top-level list element for each
        partition.  It consists of a list [<partition num>, <start>,
        <end>] where partition num is an integer, start is an integer
        holding the megabyte position where the partition starts, and
        end is an integer holding the megabyte postition of the end of
        the partition.
        """
        parts = []
        size = 0.0
        for l in _call_parted(dev, ["unit", "MB", "p"]).split('\n'): 
            words = l.split(":")
            if (not words):
                continue
            if (words[0] == dev):
                size = int(float(words[1][:-2]))
                continue
            if (words[0].isdigit()):
                parts.append((int(words[0]),
                              # truncate down the start
                              int(float(words[1][:-2])),
                              # truncate up the end
                              int(float(words[1][:-2]) + 0.9999)))
                continue
            pass
        return (size, parts)

    def _set_dev_contents(self, dev, dest, fstype, mountpoint,
                          partdev=None, partnum=None):
        if (dest == "fs"):
            subprocess.call(("mkfs." + fstype, dev))
            if (mountpoint == "/"):
                mpass = 1
            else:
                mpass = 2
                pass
            fstabe = ("echo %s\t%s\t%s\tdefaults\t0\t%d >>/tmp/fstab"
                      % (dev, mountpoint, fstype, mpass))
            subprocess.call([fstabe, ], shell=True)
        else:
            if (partdev):
                _call_parted(partdev, ["set", str(partnum), dest, "on"])
                pass
            if (dest == "lvm"):
                subprocess.call(("pvcreate", dev))
            elif (dest == "swap"):
                fstabe = ("echo %s\tswap\tswap\tsw\t0\t0 >>/tmp/fstab"
                          % (dev))
                subprocess.call([fstabe, ], shell=True)
                subprocess.call(("mkswap", "-f", dev))
                pass
            pass
        return

    def create_partition(self, dev, size, parttype, partid,
                         location=None, fstype=None, mountpoint=None):
        """Create a partition on the given device.  Returns the string
        for the new partition's device.  The given size is in megabytes.
        parttype is one of 'primary', 'logical', or 'extended'
        partid is one of 'swap', 'fs', 'lvm', 'raid'
        fstype is one of 'ext2', 'ext3', 'ext4', 'vfat' or 'xfs' and is only
                set if partid is 'fs'.
        mountpoint is the place to mount the device, only for fs partids.
        The location field take a "(start, end)" list, letting you specify
        exactly what you want.  That way you can do special parted locations.
        If location is specified, size is ignored.
        """
        if (location is None):
            (disksize, parts) = self.get_partitions(dev)
            # We assume 1MB alignment for everything, start at 1MB
            last_end = 1
            found = False
            for p in parts:
                if ((p[1] - last_end) >= size):
                    found = True
                    break
                last_end = p[2]
                pass
            if (not found):
                if ((disksize - last_end) >= size):
                    found = True
                else:
                    print(("Adding partition %s size %s, no space"
                           % (dev, size)))
                    raise InstallerException()
                pass
            start = last_end
            end = start + size
        else:
            start = location[0]
            end = location[1]
            pass

        num = _call_parted(dev, ["mkpart", parttype, str(start), str(end) ])
        lines = num.split("\n")
        num = int(lines[len(lines)-2])
        if (dev.startswith("/dev/md")):
            # Slightly different naming for md device partitions
            pdev = dev + "p" + str(num)
        else:
            pdev = dev + str(num)
            pass

        # Wait 10 seconds or so for the device node to get created by udev
        count = 0
        while (not os.access(pdev, os.F_OK)):
            count += 1
            if (count > 10):
                print("%s did not get created properly" % (pdev,))
                raise InstallerException
            time.sleep(1)
            pass

        self._set_dev_contents(pdev, partid, fstype, mountpoint,
                               partdev=dev, partnum=num)
        return pdev

    def create_raid(self, devs, dest, fstype=None, mountpoint=None):
        """Take the given list of devs and make a raid out of them.
        dest is one of "lvm", "part", or "fs".  For an fs dest, fstype
        sets the type (ext[2-4], xfs) and mountpoint sets the mount location.
        Note that if dest is "part", then fstype holds the partition type
        (msdos or gpt).
        """
        # Find the next free md device number
        dev = None
        for i in range(0, 128):
            if (not os.path.exists("/dev/md%d" % i)):
                dev = "/dev/md%d" % i
                break
            pass
        if (dev is None):
            print("No free MD device numbers")
            raise InstallerException()
            

        cmd = ["--force", "--level=1", "--metadata=0.90",
               "--run", "--raid-devices=%d" % len(devs)]
        for d in devs:
            cmd.append(d)
            pass

        _call_mdadm(dev, "--create", cmd)

        if (dest == "part"):
            # Create a partition table.
            _call_parted(dev, ["mktable", fstype])
            pass
        else:
            self._set_dev_contents(dev, dest, fstype, mountpoint)
            pass
        return dev

    def create_vg(self, devs, name):
        """Create a volume group from the given list of devices.  Note that
        these devices must have been created with their dest or partid
        set to "lvm".
        """
        cmd = [name, ]
        for d in devs:
            cmd.append(d)
            pass
        _call_lvmcmd("vgcreate", cmd)
        return name

    def create_lv(self, vg, size, name, dest, fstype=None, mountpoint=None):
        """Create a logical volume of the given size (in megabytes) and
        name. If dest is "fs",  the given fstype and mount points are
        used.  dest may also be "swap" to use the volume group as swap.
        """
        dev = "/dev/mapper/" + vg + "-" + name
        _call_lvmcmd("lvcreate", ["--name", name, "--size", str(size)+"M",
                                 "/dev/" + vg])
        self._set_dev_contents(dev, dest, fstype, mountpoint)
        return dev
    def find_devices(self, dev=None, dev_part=None):
       proc_fl = open("/proc/diskstats", "r")
       devs = []
       for l in proc_fl:
          w = l.split()
          if (dev == None):
             if (re.search(r'^sd[a-z][0-9]$', w[2])):
               devs.append("/dev/" + w[2])
          if (dev_part == None):
             if (re.search(r'^sd[a-z]$', w[2])):
               devs.append("/dev/" + w[2])
       proc_fl.close()  
       return devs

    def set_hostname(self, prompt=True):
        """Attempt to use DHCP to fetch the hostname, then prompt the user
        for the hostname if prompt is True, otherwise just set the hostname
        automatically.
        """
        if (not self.installed):
            print(("You must first install your system before setting the "
                   + "hostname"))
            raise InstallerException()

        dhcpworked = True
        # First see if dhcp works
        try:
            _call_cmd(("udhcpc", "-n", "-q", "-f"))
        except CmdErr as e:
            dhcpworked = False
            pass
        
        gothostname = False
        hostname = ""
        if (dhcpworked):
            # Create a script to handle the DHCP event and extract the
            # hostname, then call udhcpc with the script.
            f = open("/tmp/dhcp_get_hostname", "w")
            f.write("#!/bin/sh\n")
            f.write("echo $hostname >/tmp/my_hostname\n")
            f.close()
            os.chmod("/tmp/dhcp_get_hostname", stat.S_IRWXU)
            gothostname = True
            try:
                _call_cmd(("udhcpc", "-n", "-q", "-f",
                           "-s", "/tmp/dhcp_get_hostname"))
            except CmdErr as e:
                gothostname = False
                pass
            if (gothostname):
                f = open("/tmp/my_hostname", "r")
                hostname = f.readline().strip()
                f.close()
                if (hostname == ""):
                    gothostname = False
                    pass
                pass
            
            if (not gothostname):
                hostname = "host"
                print(("Unable to obtain the hostname with DHCP, defaulting to "
                       + hostname))
                pass
            
            if (prompt):
                print("Please enter the hostname")
                try:
                    x = ReadlineDefVal(hostname)
                    readline.set_startup_hook(x.hook)
                    hostname = ""
                    while (hostname == ""):
                        hostname = input("hostname> ").strip()
                        x.setvalue(hostname)
                        pass
                    pass
                finally:
                    readline.set_startup_hook(None)
                    pass
                pass
            
            f = open(self.mpref + "/etc/hostname", "w")
            f.write(hostname + "\n")
            f.close()
            pass
        
        return
    
    pass

autoinstall_help = """
This is a process that will clear out the partition tables on /dev/sd*
and create /boot and / partitions on those devices, using RAID if two disks or more available.
LVM is used to hold the / partition and /boot is set up as 200MB.
"""

autoinstall_disk_use_help = """
For creating / paritition, type 'y' for using full disk space,
'n' for using 10GB.
"""

# This is an example automatic installer to demonstrate how to
# automate an installation.  Putting this in /user_installer.py and
# naming the function "user_installer" will cause it to be executed
# instead of the normal installer.
def def_user_installer(I):
    """Create a basic install.  If two disks are available at /dev/sda1 and
    /dev/sda2, create a RAID of them for /boot and and LVM device.  Otherwise
    allocation a 200MB /boot partition and the rest to an LVM device from the
    first disk.  Then create the RAIDs, LVMs, install the image, and run grub.
    """

    print(autoinstall_help)
    d = input("Do you want to continue? (y/n) > ").strip()
    if (d != 'y'):
        return

    print(autoinstall_disk_use_help)
    d = input("Press appropiate key (y/n) > ").strip()
    if (d != 'y') and ( d != 'n'):
        print ("Returning....");  
        return  
    
    dev_lst = I.find_devices(dev=1)
    if not dev_lst:
        print("No scsi devices are connected") 
        return
   
    if (d  == 'y'):
        print ("Allocating full disk space ...");  
        sz_flg = 0
    if (d == 'n'):
        print ("Allocating 10GB size ...\n");  
        sz_flg = 1

    print("Setting up temporary fstab")
    subprocess.call(("cp", "/etc/fstab", "/tmp/fstab"))

    print("Stopping all LVM and RAID devices")
    I.clean_system()

    basedevs = I.get_base_devs()
    basedevs.sort()
    dev_lst = I.find_devices(dev_part=1) 
    for devs in dev_lst:
       _call_cmd(("mdadm", "--zero-superblock", devs), ignerr=True)  
 
    dest1 = "fs"
    dest2 = "lvm"
    if (len(basedevs) >= 2):
        # We have a RAID situation on all connected disks
        dest1 = "raid"        
        dest2 = "raid"        
        setup_devs = basedevs[:]
    else:
        setup_devs = basedevs[0:1]
        pass

    devs = []
    count = ""
    for d in setup_devs:
        # Create 200MB boot partition
        print("Clearing partition table on " + d)
        I.clear_partition_table(d)

        sys.stdout.write("Formatting boot device on " + d + "... ")
        sys.stdout.flush()
        if (efi_system):
            d1 = I.create_partition(d, 200, "primary", "fs",
                                    fstype="vfat", mountpoint="/boot/efi"
                                    + str(count))
            if (count == ""):
                count = 2
            else:
                count += 1
                pass
            pass
        else:
            d1 = I.create_partition(d, 200, "primary", dest1,
                                    fstype="ext4", mountpoint="/boot")
            pass
        print(("created " + d1))
        # Create a second partition with the rest of the disk
        sys.stdout.write("Formatting LVM device on " + d + "... ")
        sys.stdout.flush()
        # Note that because the 0.90 metadata of RAID is at the end of
        # the disk, the system cannot tell the difference between RAID
        # on the whole disk and RAID on the partition.  So move it
        # back a sector from the end of the disk so the system won't
        # see the whole disk as a RAID device.  Thus "-2s" instead of
        # "-1s"
        d2 = I.create_partition(d, None, "primary", dest2,
                                location=(201, "-2s"))
        print(("created " + d2))
        devs.append((d1, d2))
        pass

    # Get rid of any mdadm devices that accidentally came into existance
    # when the partitions were added.
    I.clean_system()

    if (not efi_system and dest1 == "raid"):
        rdevs = []
        for d in devs:
            rdevs.append(d[0])
            pass
        sys.stdout.write("Creating RAID boot device... ")
        sys.stdout.flush()
        bootdev = I.create_raid(rdevs, "fs", "ext4", "/boot")
        print(("created " + bootdev))
        pass

    if (dest2 == "raid"):
        rdevs = []
        for d in devs:
            rdevs.append(d[1])
            pass
        sys.stdout.write("Creating RAID LVM device... ")
        sys.stdout.flush()
        lvmdev = I.create_raid(rdevs, "lvm")
        print(("created " + lvmdev))
    else:
        lvmdev = devs[0][1]
        pass

    # Make sure there are no VGs created in the above process, just in
    # case they automatically came into existance.
    I.clean_vgs()
    _call_cmd(("vgchange", "-a", "n"), ignerr=True)
    

    print("Creating volume group vg01")
    vg = I.create_vg([lvmdev], "vg01")
    print("Creating logical volume root")
    
    # Find the total memory so we can calculate swap
    memcount = 0
    prog = subprocess.Popen(["free"],
                            stdin=None, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, close_fds=True)
    (out, err) = prog.communicate()
    if (prog.returncode != 0):
        print("Error finding free memory: " + err)
        print("Unable to calculate memory for swap space.")
    else:
        for l in out.split("\n"):
            w = l.split()
            if (not w):
                continue
            if (w[0] == "Mem:"):
                # Calculate memory, rounding up.
                memcount = (int(w[1]) + 999) / 1000
                pass
            pass
        pass
    sz = _call_cmd(("pvdisplay", "-C", "--noheadings", "--nosuffix", "--units", "M", lvmdev),ignerr=True) 
    if not sz:
       print("Created volume group is not good")
       return       
    sz = re.sub(' +',' ',sz)
    sz = sz.strip(' ') 
    sz = sz.strip('\n') 
    sz = sz.split(" ")
    det_sz = int(float(sz[4]) * 10/100) 
    sz = int(float(sz[4]) - det_sz) 
    
    if (memcount != 0): 
      lv_sz = int(sz) 
      if (lv_sz > int(memcount * 2)):
         lv_rt_sz = lv_sz - int(memcount  * 2)     
      else:
         memcount = 0 
         lv_rt_sz = lv_sz   
      if (sz_flg == 0):
          if (lv_rt_sz < 10000): 
             print("Insufficiant Space for Installtion")   
             return 
        
      if (sz_flg == 1): 
          if (lv_rt_sz >= 10000):   
             lv_rt_sz = 10000
          else:
             print("Insufficiant Space for Installtion")   
             return 
        

    print(("Logical volume create for Root is %dMB" % int(lv_rt_sz)))  
    print(("Logical volume create for swap is %dMB" % int(memcount * 2)))  

    

    if (sz_flg == 1):
       print("10 GB Create")
       lv = I.create_lv(vg, 10000, "root", "fs", "ext4", "/")
       if (memcount  == 0):
            print("Not creating logical volume swap")
       else:
            print(("Creating logical volume swap at 2 * memory size, or %dMB"
            % (memcount)))
            lv = I.create_lv(vg, memcount * 2, "swap", "swap")
          
    if (sz_flg == 0):
        print("Allocate full disk" + str(lv_rt_sz))
        lv = I.create_lv(vg, lv_rt_sz, "root", "fs", "ext4", "/")
        if (memcount  == 0 ):
           print("Not creating logical volume swap")
        else:
           print(("Creating logical volume swap at 2 * memory size, or %dMB"
           % (memcount * 2)))
           lv = I.create_lv(vg, memcount * 2, "swap", "swap")

    if (dest1 == "raid"):
        while True:
           out_resync = _call_cmd(("grep", "resync", "/proc/mdstat"), ignerr=True)
           if not out_resync:
              break 
           print("RAID devices under resyncing.This may go for long time...")
           sys.stdout.write("\033[F") 
           time.sleep(1)
 
    print("Mounting filesystems")
    I.reread_fstab()
    I.mount_all()
    I.installed = True

    print("Installing filesystem image")
    I.install()

    print("Setting up grub")
    I.do_grub(bootdevs="")

    print("Setting hostname")
    I.set_hostname(prompt=False)

    print("Install is complete")
    return

def default_installer():
    I = Installer()

    if (os.path.exists("/user_installer.py")):
        # Make sure we can load the user script from /
        sys.path.append("/")

        # We have a user installer, invoke it.
        try:
            import user_installer
            user_installer.user_installer(I)
            # If the user installed doesn't reboot, we fall into the main
            # installer.
        except Exception as e:
            (t, v, tb) = sys.exc_info()
            print(("Unknown error from user installer: " + str(e) + "\n"
                   + "\n".join(traceback.format_tb(tb))))
            sys.exit(1)
            pass
        pass

    print("Welcome to the MontaVista Installer!  This installer will allow")
    print("you to partition your disk and install a generated MontaVista Linux")
    print("image onto your machine.")

    menu_to_use = 0
    while (True):
        try:
            if (menu_to_use == 0):
                if (efi_system):
                    print("What would you like to do? (EFI system)")
                else:
                    print("What would you like to do?")
                    pass
                print(" 1 - Partition your hard drive(s)")
                print(" 2 - Install image and GRUB on the system ")
                print(" 3 - Recovery sub-menu")
                print(" 5 - Auto-install")
                print(" 9 - Restart the installer")
                print(" 0 - Reboot")
                sys.stdout.write("Press the key then enter: ")
                v = sys.stdin.readline()
                try:
                    v = int(v)
                except:
                    continue

                if (v == 1):
                    I.partition()
                elif (v == 2):
                    I.install()
                    I.do_grub()
                    I.set_hostname()
                elif (v == 3):
                    menu_to_use = 1
                elif (v == 5):
                    def_user_installer(I)
                    I.unmount_all()
                    break
                elif (v == 9):
                    I.unmount_all()
                    break
                elif (v == 0):
                    I.unmount_all()
                    subprocess.call(("reboot", "-f"))
                pass
            else:
                print(" 1 - Set up from an existing root partition")
                print(" 2 - Re-install grub")
                print(" 3 - Run a shell in the installed system")
                print(" 4 - Run a shell in the CD's root directory")
                print(" 5 - Set the installed system's hostname")
                print(" 0 - Return to main menu")
                sys.stdout.write("Press the key then enter: ")
                v = sys.stdin.readline()
                try:
                    v = int(v)
                except:
                    continue

                if (v == 1):
                    I.read_devs()
                    I.setup_from_existing_install()
                elif (v == 2):
                    I.do_grub()
                elif (v == 3):
                    subprocess.call(("chroot", I.mpref))
                elif (v == 4):
                    env = os.environ.copy()
                    env["PS1"] = "installer-cd# "
                    subprocess.call(("/bin/sh",), env=env)
                    del env
                elif (v == 5):
                    I.set_hostname()
                elif (v == 0):
                    menu_to_use = 0
                    pass
                pass
            pass
        except KeyboardInterrupt:
            pass
        except InstallerException:
            # An error should have already been printed
            pass
        except Exception as e:
            (t, v, tb) = sys.exc_info()
            print(("Unknown error: " + str(e) + "\n"
                   + "\n".join(traceback.format_tb(tb))))
            pass

        pass
    return

if __name__== '__main__':
    default_installer()
