#
# Copyright (C) 2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_NO_BOOTLOADER := true
TARGET_NO_RECOVERY := true
TARGET_NO_RADIOIMAGE := true

KERNEL_TOOLCHAIN := $(ANDROID_BUILD_TOP)/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin
TARGET_USES_UNCOMPRESSED_KERNEL := false
TARGET_KERNEL_CONFIG := aosp_bcm2709_b2g_defconfig

TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a7
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_BOARD_PLATFORM := bcm2709

TARGET_COMPRESS_MODULE_SYMBOLS := false
TARGET_PRELINK_MODULE := false

TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
TARGET_USERIMAGES_USE_EXT4 := true

# It looks like we cannot use 32MB with FAT32. But 48MB works.
BOARD_BOOTIMAGE_PARTITION_SIZE := 50331648 # 48M
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 536870912 # 512M
BOARD_CACHEIMAGE_PARTITION_SIZE := 134217728 # 128M
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 134217728 # 128M

PRODUCT_SUPPORTS_VERITY := false
TARGET_BOOTIMAGE_USE_EXT2 := false
TARGET_BOOTIMAGE_USE_EXTLINUX := false
TARGET_BOOTIMAGE_USE_VFAT := true

BOARD_CUSTOM_MKBOOTIMG := device/raspberrypi/rpi2b/mkbootimg_rpi2
BOARD_MKBOOTIMG_ARGS := \
    --bootcode   device/raspberrypi/rpi2b/boot/bootcode.bin \
    --configtxt  device/raspberrypi/rpi2b/boot/config.txt \
    --dt         $(ANDROID_PRODUCT_OUT)/dtbs/bcm2709-rpi-2-b.dtb \
    --fixupdat   device/raspberrypi/rpi2b/boot/fixup.dat \
    --startelf   device/raspberrypi/rpi2b/boot/start.elf \
    --partsize   $(BOARD_BOOTIMAGE_PARTITION_SIZE)

BOARD_KERNEL_CMDLINE := initrd=0x01f00000 dwc_otg.lpm_enable=0
BOARD_KERNEL_CMDLINE += console=ttyAMA0,115200 no_console_suspend root=/dev/ram0
BOARD_KERNEL_CMDLINE += elevator=deadline rootwait androidboot.hardware=rpi2b

BOARD_FLASH_BLOCK_SIZE := 4096
BOARD_MALLOC_ALIGNMENT := 16

BOARD_USES_GENERIC_AUDIO := false
BOARD_USES_USB_AUDIO := false

BOARD_EGL_CFG := device/raspberrypi/rpi2b/egl.cfg
BOARD_GPU_DRIVERS := vc4
USE_OPENGL_RENDERER := true
TARGET_USE_PAN_DISPLAY := true

USE_CAMERA_STUB := true
