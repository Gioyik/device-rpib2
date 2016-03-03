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

PRODUCT_COPY_FILES := \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    $(LOCAL_PATH)/init.rpi2b.rc:root/init.rpi2b.rc \
    $(LOCAL_PATH)/fstab.rpi2b:root/fstab.rpi2b \
    $(LOCAL_PATH)/Generic.kl:system/usr/keylayout/Generic.kl \
    $(LOCAL_PATH)/rpi-debug.sh:system/bin/rpi-debug.sh \
    $(LOCAL_PATH)/volume.cfg:system/etc/volume.cfg \
		$(LOCAL_PATH)/noobs/os.json:NOOBS/os.json \
		$(LOCAL_PATH)/noobs/partition_setup.sh:NOOBS/partition_setup.sh \
		$(LOCAL_PATH)/noobs/partitions.json:NOOBS/partitions.json \
		$(LOCAL_PATH)/noobs/fstab.rpi2b:NOOBS/fstab.rpi2b \
		$(LOCAL_PATH)/noobs/noobs_package.sh:noobs_package.sh \
    $(PRODUCT_COPY_FILES)

PRODUCT_PACKAGES += \
    libGLES_mesa \
    gralloc.rpi2b
    #hwcomposer.$(TARGET_PRODUCT)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.version = 1.0.0
    rpi.debug = 1
    rpi.debug.ipv6 = 0
    rpi.net.ip = 192.168.1.12/24
    rpi.net.gw = 192.168.1.1

INSTALL_NOOBS := true

$(call inherit-product-if-exists, vendor/raspberrypi/rpi2b/device-vendor.mk)
