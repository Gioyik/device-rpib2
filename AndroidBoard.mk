LOCAL_PATH := $(call my-dir)

ifneq ($(strip $(TARGET_INSTALL_NOOBS)),true)

LOCAL_MODULE       := noobs_package.sh
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT)

PACKAGING := $(shell ($(TARGET_OUT)/noobs_package.sh))
endif
