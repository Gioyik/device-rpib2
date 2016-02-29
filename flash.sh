ADB=${ADB:-adb}
VARIANT=${VARIANT:-eng}
FULLFLASH=false
SLICE="p"
BS_SLICE="M"
BMAPTOOL=false

if [ ! -f "`which \"$ADB\"`" ]; then
	ADB=out/host/`uname -s | tr "[[:upper:]]" "[[:lower:]]"`-x86/bin/adb
fi

run_adb()
{
	$ADB $ADB_FLAGS $@
}

get_drive_slice()
{
	case `uname` in
  "Darwin")
    SLICE="s"
    ;;
  "Linux")
    SLICE="p"
    ;;
  *)
    echo Unsupported platform: `uname`
    exit -1
  esac
}

get_drive_slice

get_bs_slice()
{
	case `uname` in
  "Darwin")
    BS_SLICE="m"
    ;;
  "Linux")
    BS_SLICE="M"
    ;;
  *)
    echo Unsupported platform: `uname`
    exit -1
  esac
}

get_bs_slice

is_bmaptool()
{
	bmaptool
	if [ $? -eq 0 ]; then
	    BMAPTOOL=true
	else
	    BMAPTOOL=false
	fi
}

is_bmaptool

update_time()
{
	if [ `uname` = Darwin ]; then
		OFFSET=`date +%z`
		OFFSET=${OFFSET:0:3}
		TIMEZONE=`date +%Z$OFFSET|tr +- -+`
	else
		TIMEZONE=`date +%Z%:::z|tr +- -+`
	fi
	echo Attempting to set the time on the device
	run_adb wait-for-device &&
	run_adb shell "toolbox date $(date +%s) ||
	               toolbox date -s $(date +%Y%m%d.%H%M%S)" &&
	run_adb shell setprop persist.sys.timezone $TIMEZONE
}

sd_partition()
{
  DRIVE=$2

  if [ -z "${DRIVE}" ]; then
    echo You must specify a SD card drive
  fi

  umount $DRIVE

  dd if=/dev/zero of=$DRIVE bs=1024

  sed -e 's/\t\([\+0-9a-zA-Z]*\)[ \t].*/\1/' << EOF | fdisk ${DRIVE}
    o # clear the in memory partition table
    n # new partition
    p # primary partition
    1 # partition number 1
      # default - start at beginning of disk
    +48M # 48 MB boot parttion
    n # new partition
    p # primary partition
    2 # partition number 2
      # default, start immediately after preceding partition
    +537M # 537 MB boot parttion
    n # new partition
    p # primary partition
    3 # partition number 3
      # default, start immediately after preceding partition
    +128M # 128 MB boot parttion
    n # new partition
    p # primary partition
    4 # partition number 4
      # default, start immediately after preceding partition
      # default, extend partition to end of disk
    a # make a partition bootable
    1 # bootable partition is partition 1 -- /dev/xxxx1
    p # print the in-memory partition table
    w # write the partition table
    q # finish
  EOF

	e2fsck -f ${DRIVE}${SLICE}4

  resize2fs -f ${DRIVE}${SLICE}4

}

flash_image()
{
  DRIVE=$2

  if [ -z "${DRIVE}" ]; then
    echo You must specify a SD card drive
  fi

  umount $DRIVE

  if [ -e "out/target/product/$DEVICE/boot.img" ]; then
		if $BMAPTOOL; then
			bmaptool copy out/target/product/${DEVICE}/boot.img ${DRIVE}${SLICE}1
		else
			dd if=out/target/product/${DEVICE}/boot.img of=${DRIVE}${SLICE}1 bs=1${BS_SLICE}
		fi
  fi

	if [ -e "out/target/product/$DEVICE/system.img" ]; then
		if $BMAPTOOL; then
			bmaptool copy out/target/product/${DEVICE}/system.img ${DRIVE}${SLICE}2
		else
			dd if=out/target/product/${DEVICE}/system.img of=${DRIVE}${SLICE}2 bs=1${BS_SLICE}
		fi
  fi

	if [ -e "out/target/product/$DEVICE/cache.img" ]; then
		if $BMAPTOOL; then
			bmaptool copy out/target/product/${DEVICE}/cache.img ${DRIVE}${SLICE}3
		else
		dd if=out/target/product/${DEVICE}/cache.img of=${DRIVE}${SLICE}3 bs=1${BS_SLICE}
  fi

	if [ -e "out/target/product/$DEVICE/userdata.img" ]; then
		if $BMAPTOOL; then
			bmaptool copy out/target/product/${DEVICE}/userdata.img ${DRIVE}${SLICE}4
		else
			dd if=out/target/product/${DEVICE}/userdata.img of=${DRIVE}${SLICE}4 bs=1${BS_SLICE}
		fi
  fi
}

flash_gecko()
{
	delete_extra_gecko_files_on_device &&
	run_adb push $GECKO_OBJDIR/dist/b2g /system/b2g &&
	return 0
}

flash_gaia()
{
	GAIA_MAKE_FLAGS="ADB=\"$ADB\""
	USER_VARIANTS="user(debug)?"
	# We need to decide where to push the apps here.
	# If the VARIANTS is user or userdebug, send them to /system/b2g.
	# or, we will try to connect the phone and see where Gaia was installed
	# and try not to push to the wrong place.
	if [[ "$VARIANT" =~ $USER_VARIANTS ]]; then
		# Gaia's build takes care of remounting /system for production builds
		echo "Push to /system/b2g ..."
		GAIA_MAKE_FLAGS+=" GAIA_INSTALL_PARENT=/system/b2g"
	else
		echo "Detect GAIA_INSTALL_PARENT ..."
		# This part has been re-implemented in Gaia build script (bug 915484),
		# XXX: Remove this once we no longer support old Gaia branches.
		# Install to /system/b2g if webapps.json does not exist, or
		# points any installed app to /system/b2g.
		run_adb wait-for-device
		if run_adb shell 'cat /data/local/webapps/webapps.json || echo \"basePath\": \"/system\"' | grep -qs '"basePath": "/system' ; then
			echo "Push to /system/b2g ..."
			GAIA_MAKE_FLAGS+=" GAIA_INSTALL_PARENT=/system/b2g"
		else
			echo "Push to /data/local ..."
			GAIA_MAKE_FLAGS+=" GAIA_INSTALL_PARENT=/data/local"
		fi
	fi
	make -C gaia push $GAIA_MAKE_FLAGS

	# For older Gaia without |push| target,
	# run the original |install-gaia| target.
	# XXX: Remove this once we no longer support old Gaia branches.
	if [[ $? -ne 0 ]]; then
		make -C gaia install-gaia $GAIA_MAKE_FLAGS
	fi
	return $?
}

while [ $# -gt 0 ]; do
	case "$1" in
	"-s")
		ADB_FLAGS+="-s $2"
		shift
		;;
	"-f")
		FULLFLASH=true
		;;
	"-h"|"--help")
		echo "Usage: $0 [-s device] [-f] [project]"
		exit 0
		;;
	"-"*)
		echo "$0: Unrecognized option: $1"
		exit 1
		;;
	*)
		PROJECT=$1
		;;
	esac
	shift
done

if $FULLFLASH; then
  sd_partition $2 &&
  flash_image $2

  exit $?
else
  case "$PROJECT" in
  "shallow")
  	resp=`run_adb root` || exit $?
  	[ "$resp" != "adbd is already running as root" ] && run_adb wait-for-device
  	run_adb shell stop b2g &&
  	run_adb remount &&
  	flash_gecko &&
  	flash_gaia &&
  	update_time &&
  	echo Restarting B2G &&
  	run_adb shell start b2g
  	exit $?
  	;;

  "gecko")
  	resp=`run_adb root` || exit $?
  	[ "$resp" != "adbd is already running as root" ] && run_adb wait-for-device
  	run_adb shell stop b2g &&
  	run_adb remount &&
  	flash_gecko &&
  	echo Restarting B2G &&
  	run_adb shell start b2g
  	exit $?
  	;;

  "gaia")
  	flash_gaia
  	exit $?
  	;;

  "time")
  	update_time
  	exit $?
  	;;

  "partition")
  	sd_partition $2
  	exit $?
  	;;
  esac
fi
exit $?
;;
