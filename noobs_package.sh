#! /bin/bash

mkdir NOOBS

echo "Creating tar archives for NOOBS"
tar -cvpf NOOBS/userdata.tar data/
tar -cvpf NOOBS/system.tar system/
tar -cvpf NOOBS/boot.tar boot/
tar -cvpf NOOBS/cache.tar cache/

echo "Creating xz archives for NOOBS"
xz -9 -e NOOBS/userdata.tar
xz -9 -e NOOBS/system.tar
xz -9 -e NOOBS/boot.tar
xz -9 -e NOOBS/cache.tar

echo "Zipping B2G for NOOBS into package"
zip -r B2G_NOOBS_PACKAGE.zip NOOBS/
