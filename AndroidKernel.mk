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

#Android makefile to build kernel as a part of Android Build
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
TARGET_PREBUILT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/zImage

$(TARGET_PREBUILT_KERNEL) : $(KERNEL_OUT) $(KERNEL_CONFIG)
       $(MAKE) -C kernel ARM=arm CROSS_COMPILE=arm-eabi- O=../$(KERNEL_OUT) kernel.img

$(KERNEL_CONFIG) : $(KERNEL_OUT)
       ARCH=arm scripts/kconfig/merge_config.sh arch/arm/configs/$(KERNEL_DEFCONFIG) android/configs/android-base.cfg android/configs/android-recommended.cfg
       ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make zImage
       ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make dtbs

$(KERNEL_OUT) :
	mkdir -p $(KERNEL_OUT)

.PHONY : $(KERNEL_CONFIG) $(TARGET_PREBUILT_KERNEL)
