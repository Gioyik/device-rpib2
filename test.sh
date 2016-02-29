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

flash_image()
{

  echo $1
	echo $2

  if [ -e "out/target/product/$DEVICE/$3.img" ]; then
  	dd if=out/target/product/${DEVICE}/$3.img of=${DRIVE} bs=1${BS_SLICE}
  fi

	echo ${SLICE}
}

flash_image $2 boot
