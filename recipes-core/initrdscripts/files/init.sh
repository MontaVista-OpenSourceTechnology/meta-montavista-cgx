#!/bin/sh

MODULE_DIR=/initrd.d
BOOT_ROOT=/root
ROOT_DEVICE=
INIT=/sbin/init

early_setup() {
    mkdir -p /proc /sys /mnt /tmp /root

    mount -t proc proc /proc
    mount -t sysfs sysfs /sys
    mount -t devtmpfs udev /dev

    modprobe -q mtdblock
}

dev_setup()
{
    echo -n "initramfs: Creating device nodes: "
    grep '^ *[0-9]' /proc/partitions | while read major minor blocks dev
    do
        if [ ! -e /dev/$dev ]; then
            echo -n "$dev "
            [ -e /dev/$dev ] || mknod /dev/$dev b $major $minor
        fi
    done
    echo
}

read_args() {
    [ -z "$CMDLINE" ] && CMDLINE=`cat /proc/cmdline`
    for arg in $CMDLINE; do
        optarg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
        case $arg in
            root=*)
                ROOT_DEVICE=$optarg ;;
	    init=*)
		INIT=$optarg ;;
            rootfstype=*)
                ROOT_FSTYPE=$optarg ;;
            rootdelay=*)
                rootdelay=$optarg ;;
	    cryptdevice=*)
		cryptdevice=$optarg ;;
            debug) set -x ;;
            shell) sh ;;
        esac
    done
}

encrypted_boot_root() {
	
	# Export relevant variables
	export rootfstype=
	export root=
	export init=/sbin/init
	export cryptdevice=
	export crypto=
	export cryptkey=
	export cryptdev=
	export mapperdev=
	export cipher=
	export hash=
	export type=
	export keysize=
	# Parse command line options
	for x in $(cat /proc/cmdline); do
		case $x in
		init=*)
			init=${x#init=}
			;;
		root=*)
			root=${x#root=}
                	;;
		cryptdevice=*)
			cryptdevice=${x#cryptdevice=}
			;;
		crypto=*)
                	crypto=${x#crypto=}
                	;;
		cryptkey=*)
                	cryptkey=${x#cryptkey=}
                	;;
		rootfstype=*)
			rootfstype="${x#rootfstype=}"
			;;
		esac
	done
	if [ $cryptdevice ]; then   
                cryptdev="$(echo $cryptdevice | cut -d':' -f1 )"
                mapperdev="$(echo $cryptdevice | cut -d':' -f2 )"
        fi                     

        if [ $crypto ]; then
                hash="$(echo $crypto | cut -d':' -f1 )"
                cipher="$(echo $crypto | cut -d':' -f2 )" 
                keysize="$(echo $crypto | cut -d':' -f3 )"
                type="$(echo $crypto | cut -d':' -f4 )"
                                              	
		test -e $cryptdev || sleep 5

		if [ $cryptkey ]; then	
		/sbin/cryptsetup --cipher=$cipher --key-size=$keysize --hash=$hash --type=$type --key-file=$cryptkey luksOpen $cryptdev $mapperdev 
		else
		/sbin/cryptsetup --cipher=$cipher --key-size=$keysize --hash=$hash --type=$type luksOpen $cryptdev $mapperdev >$CONSOLE
		fi
	fi

	[ -e /dev/mapper/${mapperdev} ] && ROOT_DEVICE=$root
	[ $init ] && INIT=$init	
}

do_depmod() {
	[ -e "/lib/modules/$(uname -r)/modules.dep" ] || depmod
}

load_module() {
    # Cannot redir to $CONSOLE here easily - may not be set yet
    echo "initramfs: Loading $module module"
    source $1
}

load_modules() {
    for module in $MODULE_DIR/$1; do
        [ -e "$module"  ] && load_module $module
    done
}

boot_root() {
	mount $ROOT_DEVICE $BOOT_ROOT
	exec switch_root $BOOT_ROOT $INIT
}

fatal() {
    echo $1 >$CONSOLE
    echo >$CONSOLE
    exec bash
}


echo "Starting initramfs boot..."
early_setup
load_modules '0*'
do_depmod

[ -z "$CONSOLE" ] && CONSOLE="/dev/console"

read_args

if [ -z "$rootdelay" ]; then
    echo "rootdelay parameter was not passed on kernel command line - assuming 2s delay"
    echo "If you would like to avoid this delay, pass explicit rootdelay=0"
    rootdelay="2"
fi
if [ -n "$rootdelay" ]; then
    echo "Waiting $rootdelay seconds for devices to settle..." >$CONSOLE
    sleep $rootdelay
fi

dev_setup

load_modules '[1-9]*'
[ $cryptdevice ] && encrypted_boot_root

[ $ROOT_DEVICE ] || exec bash
test -e $ROOT_DEVICE || sleep 5
[ -e $ROOT_DEVICE ] && boot_root

fatal "No valid root device was specified.  Please add root=/dev/something to the kernel command-line and try again."
