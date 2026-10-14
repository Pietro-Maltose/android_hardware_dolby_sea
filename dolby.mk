#
# Dolby DAX 3.12 for Redmi Note 12S (sea / MT6781)
# SPDX-License-Identifier: Apache-2.0
#
# Add to the device tree:   $(call inherit-product, hardware/dolby/dolby.mk)
# AND register the effect in audio_effects_config.xml (see scripts/ and README.md).

DOLBY_PATH := hardware/dolby

PRODUCT_SOONG_NAMESPACES += $(DOLBY_PATH)

# Sepolicy (vendor)
BOARD_VENDOR_SEPOLICY_DIRS += $(DOLBY_PATH)/sepolicy/vendor

# Framework compatibility matrix: lets the system servicemanager accept vendor.dolby.dms.IDms/default
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DOLBY_PATH)/vintf/dolby_framework_matrix.xml

# Config
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/proprietary/vendor/etc/dolby/dax-default.xml:$(TARGET_COPY_OUT_VENDOR)/etc/dolby/dax-default.xml \
    $(DOLBY_PATH)/proprietary/vendor/etc/init/dms-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/dms-service.rc

# Vendor properties
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.dolby.dax.version=DAX3_3.12.0.8_r1

# Blobs, HAL, vintf fragment, init rc
PRODUCT_PACKAGES += \
    init.dolby.rc \
    libdapparamstorage \
    libdeccfg \
    libdlbdsservice \
    libdlbpreg \
    libdmshal \
    liboem_specific \
    libswdapaidl \
    libstagefright_foundation-v33.dolby \
    vendor.dolby.dms-V1-ndk \
    vendor.dolby.hardware.dms@2.0 \
    vendor.dolby.dms.service \
    dms-service.xml

# App + framework overlay (swap for LunarisDolbyPrebuilt if the source app fails to build)
PRODUCT_PACKAGES += \
    LunarisDolby \
    DolbyFrameworksResCommon
