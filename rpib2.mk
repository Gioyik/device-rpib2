$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

include frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk

PRODUCT_PACKAGES += \
    libGLES_android

PRODUCT_COPY_FILES := \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    device/generic/goldfish/camera/media_profiles.xml:system/etc/media_profiles.xml \
    device/generic/goldfish/camera/media_codecs.xml:system/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    $(LOCAL_PATH)/rpib2_core_hardware.xml:system/etc/permissions/rpib2_core_hardware.xml \
    $(LOCAL_PATH)/init.rpib2.rc:root/init.rpib2.rc \
    $(LOCAL_PATH)/init.usb.rc:root/init.usb.rc \
    $(LOCAL_PATH)/fstab.rpib2:root/fstab.rpib2 \
    $(LOCAL_PATH)/Generic.kl:system/usr/keylayout/Generic.kl \
    $(PRODUCT_COPY_FILES)

DEVICE_PACKAGE_OVERLAYS := device/brcm/rpib2/overlay
PRODUCT_CHARACTERISTICS := tablet,nosdcard
PRODUCT_LOCALES := en_US

PRODUCT_AAPT_CONFIG :=nomal tvdpi hdpi
PRODUCT_AAPT_PREF_CONFIG := tvdpi

PRODUCT_NAME := rpib2
PRODUCT_DEVICE := rpib2
PRODUCT_BRAND := raspberry
PRODUCT_MANUFACTER := brcm
PRODUCT_MODEL := rpib2