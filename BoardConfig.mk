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

TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi

TARGET_NO_RECOVERY := true
TARGET_NO_RADIOIMAGE := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_KERNEL_SOURCE := kernel/raspberrypi/rpib2

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 576716800
BOARD_BOOTIMAGE_PARTITION_SIZE := 104857600
BOARD_CACHEIMAGE_PARTITION_SIZE := 69206016
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 576716800

BOARD_FLASH_BLOCK_SIZE := 512
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

BOARD_EGL_CFG := device/raspberrypi/rpib2/egl_mesa.cfg
BOARD_GPU_DRIVERS := vc4
USE_OPENGL_RENDERER := true
PRODUCT_PROPERTY_OVERRIDES += ro.opengles.version = 131072
BOARD_USES_GENERIC_AUDIO := false
USE_CAMERA_STUB := true