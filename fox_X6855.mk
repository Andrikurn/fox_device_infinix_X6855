#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from Infinix-X6855 device
$(call inherit-product, device/infinix/X6855/device.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Include TWRP props.
$(call inherit-product, device/infinix/X6855/twrp.mk)

# Include Fox props.
$(call inherit-product, device/infinix/X6855/fox.mk)

# Product Specifics
PRODUCT_NAME := fox_X6855
PRODUCT_DEVICE := X6855
PRODUCT_BRAND := Infinix
PRODUCT_MODEL := Infinix X6855
PRODUCT_MANUFACTURER := INFINIX

PRODUCT_GMS_CLIENTID_BASE := android-transsion
