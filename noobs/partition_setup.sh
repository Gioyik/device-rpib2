#!/bin/sh

set -ex

if [ -z "$part1" ] || [ -z "$part2" ] || [ -z "$part3" ] || [ -z "$part4" ]; then
  printf "Error: missing environment variable part1 or part2\n" 1>&2
  exit 1
fi

mkdir -p /tmp/2

mount "$part2" /tmp/2

partition2=$part2
partition3=$part3
partition4=$part4

p2=${partition2/\/dev\/}
p3=${partition3/\/dev\/}
p4=${partition4/\/dev\/}

echo "# fstab file.
#<src>                  <mnt_point>         <type>    <mnt_flags and options>                               <fs_mgr_flags>
# The filesystem that contains the filesystem checker binary (typically /system) cannot
# specify MF_CHECK, and must come before any filesystems that do specify MF_CHECK

/dev/block/$p2    /system             ext4      ro                                                    wait
/dev/block/$p3    /cache              ext4      noatime,nosuid,nodev,nomblk_io_submit,errors=panic    wait
/dev/block/$p4    /data               ext4      noatime,nosuid,nodev,nomblk_io_submit,errors=panic    wait
" > /tmp/2/fstab.rpi2b

umount /tmp/2
